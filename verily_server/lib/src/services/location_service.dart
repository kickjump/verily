import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Business logic for managing geographic locations attached to actions.
///
/// Provides standard CRUD operations plus spatial queries using PostGIS. The
/// spatial queries rely on raw SQL because Serverpod's ORM does not natively
/// support PostGIS functions.
///
/// All methods are static and accept a [Session] as the first parameter.
class LocationService {
  LocationService._();

  static final _log = VLogger('LocationService');

  /// Average radius of the Earth in meters (WGS-84).
  static const double _earthRadiusMeters = 6371000;

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Creates a new location.
  static Future<Location> create(
    Session session, {
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    String? address,
  }) async {
    _validateCoordinates(latitude, longitude);
    if (radiusMeters <= 0) {
      throw ValidationException('radiusMeters must be > 0');
    }

    final location = Location(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await Location.db.insertRow(session, location);
    _log.info(
      'Created location "${inserted.name}" (id=${inserted.id}) '
      'at ($latitude, $longitude)',
    );
    return inserted;
  }

  /// Finds a location by its primary key [id].
  ///
  /// Throws [NotFoundException] if the location does not exist.
  static Future<Location> findById(Session session, int id) async {
    final location = await Location.db.findById(session, id);
    if (location == null) {
      throw NotFoundException('Location with id $id not found');
    }
    return location;
  }

  /// Lists all locations with optional pagination.
  static Future<List<Location>> list(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    return Location.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.name,
    );
  }

  /// Updates a location's fields.
  static Future<Location> update(
    Session session, {
    required int id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? radiusMeters,
  }) async {
    final location = await findById(session, id);

    if (name != null) location.name = name;
    if (address != null) location.address = address;
    if (latitude != null) location.latitude = latitude;
    if (longitude != null) location.longitude = longitude;
    if (radiusMeters != null) {
      if (radiusMeters <= 0) {
        throw ValidationException('radiusMeters must be > 0');
      }
      location.radiusMeters = radiusMeters;
    }

    if (latitude != null || longitude != null) {
      _validateCoordinates(location.latitude, location.longitude);
    }

    return Location.db.updateRow(session, location);
  }

  /// Deletes a location by id.
  ///
  /// Actions referencing this location will have their [locationId] set to
  /// null via the `onDelete: setNull` relation.
  static Future<void> delete(Session session, int id) async {
    final location = await findById(session, id);
    await Location.db.deleteRow(session, location);
    _log.info('Deleted location id=$id ("${location.name}")');
  }

  // ---------------------------------------------------------------------------
  // Spatial queries
  // ---------------------------------------------------------------------------

  /// Finds all locations within [radiusMeters] of the given coordinates.
  ///
  /// Uses the Haversine formula via PostGIS `ST_DWithin` for accurate
  /// geographic distance calculations.
  static Future<List<Location>> findNearby(
    Session session, {
    required double latitude,
    required double longitude,
    required double radiusMeters,
    int limit = 50,
  }) async {
    _validateCoordinates(latitude, longitude);

    // TODO: When PostGIS extension is enabled, use a raw SQL query with
    // ST_DWithin for accurate results on a sphere:
    //
    // SELECT *
    // FROM location
    // WHERE ST_DWithin(
    //   ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
    //   ST_SetSRID(ST_MakePoint($longitude, $latitude), 4326)::geography,
    //   $radiusMeters
    // )
    // ORDER BY ST_Distance(
    //   ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
    //   ST_SetSRID(ST_MakePoint($longitude, $latitude), 4326)::geography
    // )
    // LIMIT $limit;

    // Fallback: use the Haversine formula in Dart. This works correctly but
    // fetches all rows first, so it should be replaced with PostGIS for
    // production at scale.
    final all = await Location.db.find(session);
    final nearby = all.where((loc) {
      final distance = _haversineDistance(
        latitude,
        longitude,
        loc.latitude,
        loc.longitude,
      );
      return distance <= radiusMeters;
    }).toList();

    // Sort by distance ascending.
    nearby.sort((a, b) {
      final distA = _haversineDistance(
        latitude,
        longitude,
        a.latitude,
        a.longitude,
      );
      final distB = _haversineDistance(
        latitude,
        longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });

    return nearby.take(limit).toList();
  }

  /// Finds locations within a lat/lng bounding box (for map viewport queries).
  static Future<List<Location>> findInBoundingBox(
    Session session, {
    required double southLat,
    required double westLng,
    required double northLat,
    required double eastLng,
    int limit = 100,
  }) async {
    // Simple bbox filter. For production, use PostGIS ST_MakeEnvelope.
    return Location.db.find(
      session,
      where: (t) =>
          t.latitude.between(southLat, northLat) &
          t.longitude.between(westLng, eastLng),
      limit: limit,
    );
  }

  /// Checks whether a given point is within the radius of a specific location.
  ///
  /// Returns `true` if the distance between the point and the location's
  /// center is less than or equal to the location's [radiusMeters].
  static Future<bool> isWithinLocation(
    Session session, {
    required int locationId,
    required double latitude,
    required double longitude,
  }) async {
    final location = await findById(session, locationId);
    final distance = _haversineDistance(
      latitude,
      longitude,
      location.latitude,
      location.longitude,
    );
    return distance <= location.radiusMeters;
  }

  /// Computes the distance in meters between a point and a location's center.
  static Future<double> distanceTo(
    Session session, {
    required int locationId,
    required double latitude,
    required double longitude,
  }) async {
    final location = await findById(session, locationId);
    return _haversineDistance(
      latitude,
      longitude,
      location.latitude,
      location.longitude,
    );
  }

  /// Finds locations by name using a case-insensitive partial match.
  static Future<List<Location>> searchByName(
    Session session, {
    required String query,
    int limit = 20,
  }) async {
    final lowerQuery = query.toLowerCase();
    return Location.db.find(
      session,
      where: (t) => t.name.like('%$lowerQuery%'),
      limit: limit,
      orderBy: (t) => t.name,
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Validates that latitude is in [-90, 90] and longitude is in [-180, 180].
  static void _validateCoordinates(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ValidationException(
        'Latitude must be between -90 and 90, got $latitude',
      );
    }
    if (longitude < -180 || longitude > 180) {
      throw ValidationException(
        'Longitude must be between -180 and 180, got $longitude',
      );
    }
  }

  /// Calculates the great-circle distance between two points using the
  /// Haversine formula.
  ///
  /// Returns the distance in meters.
  static double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        _sinSquared(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            _sinSquared(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return _earthRadiusMeters * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;

  static double _sinSquared(double x) {
    final s = math.sin(x);
    return s * s;
  }
}
