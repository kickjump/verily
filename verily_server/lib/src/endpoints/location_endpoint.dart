import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/location_service.dart';

/// Endpoint for managing geographic locations.
///
/// All methods require authentication. Locations can be attached to actions
/// to require geographic proximity for performing them.
class LocationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new location.
  Future<Location> create(Session session, Location location) async {
    return LocationService.create(
      session,
      name: location.name,
      latitude: location.latitude,
      longitude: location.longitude,
      radiusMeters: location.radiusMeters,
      address: location.address,
    );
  }

  /// Searches for locations near a geographic coordinate.
  Future<List<Location>> searchNearby(
    Session session,
    double lat,
    double lng,
    double radiusMeters,
  ) async {
    return LocationService.findNearby(
      session,
      latitude: lat,
      longitude: lng,
      radiusMeters: radiusMeters,
    );
  }

  /// Retrieves a single location by its ID.
  Future<Location?> get(Session session, int id) async {
    return LocationService.findById(session, id);
  }
}
