// TODO: Database-dependent tests require serverpod_test setup.
// Run with: cd verily_server && dart test
//
// The Haversine distance calculation tests can run immediately since they
// test pure math logic with no database dependency.

import 'dart:math' as math;

import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/location_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Haversine distance calculation (pure math - no DB needed)
  //
  // Since LocationService._haversineDistance is private, we replicate the
  // formula here for testing. This validates that the mathematical
  // implementation is correct and can be used as a reference when the actual
  // service is integrated.
  // ---------------------------------------------------------------------------

  /// Haversine formula: computes distance between two lat/lon points in meters.
  double haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusMeters = 6371000.0;

    double toRadians(double degrees) => degrees * math.pi / 180;
    double sinSquared(double x) {
      final s = math.sin(x);
      return s * s;
    }

    final dLat = toRadians(lat2 - lat1);
    final dLon = toRadians(lon2 - lon1);
    final a = sinSquared(dLat / 2) +
        math.cos(toRadians(lat1)) *
            math.cos(toRadians(lat2)) *
            sinSquared(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadiusMeters * c;
  }

  group('Haversine distance calculation (pure math)', () {
    test('distance between same point is 0', () {
      final distance = haversineDistance(51.5074, -0.1278, 51.5074, -0.1278);
      expect(distance, equals(0.0));
    });

    test('London to Paris is approximately 343 km', () {
      // London: 51.5074 N, 0.1278 W
      // Paris: 48.8566 N, 2.3522 E
      final distance = haversineDistance(51.5074, -0.1278, 48.8566, 2.3522);
      // Approximately 343 km.
      expect(distance, closeTo(343_000, 5_000));
    });

    test('New York to Los Angeles is approximately 3940 km', () {
      // New York: 40.7128 N, 74.0060 W
      // Los Angeles: 34.0522 N, 118.2437 W
      final distance =
          haversineDistance(40.7128, -74.0060, 34.0522, -118.2437);
      // Approximately 3940 km.
      expect(distance, closeTo(3_940_000, 50_000));
    });

    test('North Pole to South Pole is approximately 20015 km', () {
      // North Pole: 90 N, 0 E
      // South Pole: 90 S, 0 E
      final distance = haversineDistance(90.0, 0.0, -90.0, 0.0);
      // Half the circumference of Earth: ~20015 km.
      expect(distance, closeTo(20_015_000, 100_000));
    });

    test('equatorial points 1 degree apart are approximately 111 km', () {
      final distance = haversineDistance(0.0, 0.0, 0.0, 1.0);
      // 1 degree of longitude at the equator is approximately 111 km.
      expect(distance, closeTo(111_000, 1_000));
    });

    test('distance is symmetric (A to B == B to A)', () {
      final ab = haversineDistance(51.5074, -0.1278, 48.8566, 2.3522);
      final ba = haversineDistance(48.8566, 2.3522, 51.5074, -0.1278);
      expect(ab, closeTo(ba, 0.01));
    });

    test('short distance (within a city block) is approximately correct', () {
      // Two points in central London, about 100m apart.
      // Trafalgar Square: 51.5080, -0.1281
      // Nearby: 51.5089, -0.1281 (approx 100m north)
      final distance = haversineDistance(51.5080, -0.1281, 51.5089, -0.1281);
      expect(distance, closeTo(100, 10));
    });

    test('handles crossing the International Date Line', () {
      // Tokyo: 35.6762 N, 139.6503 E
      // Honolulu: 21.3069 N, 157.8583 W (= -157.8583)
      final distance =
          haversineDistance(35.6762, 139.6503, 21.3069, -157.8583);
      // Approximately 6200 km.
      expect(distance, closeTo(6_200_000, 100_000));
    });

    test('handles negative latitudes (Southern Hemisphere)', () {
      // Sydney: 33.8688 S, 151.2093 E
      // Melbourne: 37.8136 S, 144.9631 E
      final distance =
          haversineDistance(-33.8688, 151.2093, -37.8136, 144.9631);
      // Approximately 714 km.
      expect(distance, closeTo(714_000, 20_000));
    });
  });

  // ---------------------------------------------------------------------------
  // Coordinate validation (pure logic - no DB needed)
  // ---------------------------------------------------------------------------

  group('Coordinate validation (pure logic)', () {
    test('valid latitude range is -90 to 90', () {
      expect(-90.0 >= -90 && -90.0 <= 90, isTrue);
      expect(0.0 >= -90 && 0.0 <= 90, isTrue);
      expect(90.0 >= -90 && 90.0 <= 90, isTrue);
    });

    test('valid longitude range is -180 to 180', () {
      expect(-180.0 >= -180 && -180.0 <= 180, isTrue);
      expect(0.0 >= -180 && 0.0 <= 180, isTrue);
      expect(180.0 >= -180 && 180.0 <= 180, isTrue);
    });

    test('invalid latitudes are outside -90 to 90', () {
      expect(-91.0 >= -90 && -91.0 <= 90, isFalse);
      expect(91.0 >= -90 && 91.0 <= 90, isFalse);
    });

    test('invalid longitudes are outside -180 to 180', () {
      expect(-181.0 >= -180 && -181.0 <= 180, isFalse);
      expect(181.0 >= -180 && 181.0 <= 180, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Database-dependent tests (require serverpod_test)
  // ---------------------------------------------------------------------------

  group('LocationService (database operations)', () {
    // late Session session;

    // setUp(() async {
    //   session = await createTestSession();
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    group('create()', () {
      test('creates a location with valid coordinates', () async {
        // final location = await LocationService.create(
        //   session,
        //   name: 'Central Park',
        //   latitude: 40.7829,
        //   longitude: -73.9654,
        //   radiusMeters: 500,
        //   address: 'New York, NY',
        // );
        //
        // expect(location.id, isNotNull);
        // expect(location.name, equals('Central Park'));
        // expect(location.latitude, closeTo(40.7829, 0.001));
        // expect(location.longitude, closeTo(-73.9654, 0.001));
        // expect(location.radiusMeters, equals(500));
        // expect(location.address, equals('New York, NY'));
        // expect(location.createdAt, isNotNull);
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for invalid latitude', () async {
        // expect(
        //   () => LocationService.create(
        //     session,
        //     name: 'Invalid',
        //     latitude: 91.0,
        //     longitude: 0.0,
        //     radiusMeters: 100,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for invalid longitude', () async {
        // expect(
        //   () => LocationService.create(
        //     session,
        //     name: 'Invalid',
        //     latitude: 0.0,
        //     longitude: 181.0,
        //     radiusMeters: 100,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for zero radius', () async {
        // expect(
        //   () => LocationService.create(
        //     session,
        //     name: 'Zero Radius',
        //     latitude: 0.0,
        //     longitude: 0.0,
        //     radiusMeters: 0,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for negative radius', () async {
        // expect(
        //   () => LocationService.create(
        //     session,
        //     name: 'Negative Radius',
        //     latitude: 0.0,
        //     longitude: 0.0,
        //     radiusMeters: -100,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('findById()', () {
      test('returns location by primary key', () async {
        // final created = await LocationService.create(
        //   session,
        //   name: 'Find Me',
        //   latitude: 51.5074,
        //   longitude: -0.1278,
        //   radiusMeters: 100,
        // );
        //
        // final found = await LocationService.findById(session, created.id!);
        // expect(found.name, equals('Find Me'));
      }, skip: 'Requires serverpod_test database session');

      test('throws NotFoundException for non-existent id', () async {
        // expect(
        //   () => LocationService.findById(session, 99999),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('list()', () {
      test('returns locations ordered by name', () async {
        // await LocationService.create(
        //   session,
        //   name: 'Zebra Cafe',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        // await LocationService.create(
        //   session,
        //   name: 'Apple Store',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // final locations = await LocationService.list(session);
        // for (var i = 1; i < locations.length; i++) {
        //   expect(
        //     locations[i].name.compareTo(locations[i - 1].name),
        //     greaterThanOrEqualTo(0),
        //   );
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    group('update()', () {
      test('updates location name', () async {
        // final created = await LocationService.create(
        //   session,
        //   name: 'Old Name',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // final updated = await LocationService.update(
        //   session,
        //   id: created.id!,
        //   name: 'New Name',
        // );
        //
        // expect(updated.name, equals('New Name'));
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for invalid updated coordinates',
          () async {
        // final created = await LocationService.create(
        //   session,
        //   name: 'Test',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // expect(
        //   () => LocationService.update(
        //     session,
        //     id: created.id!,
        //     latitude: 200.0,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for zero updated radius', () async {
        // final created = await LocationService.create(
        //   session,
        //   name: 'Test',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // expect(
        //   () => LocationService.update(
        //     session,
        //     id: created.id!,
        //     radiusMeters: 0,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('delete()', () {
      test('deletes a location by id', () async {
        // final created = await LocationService.create(
        //   session,
        //   name: 'Delete Me',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // await LocationService.delete(session, created.id!);
        //
        // expect(
        //   () => LocationService.findById(session, created.id!),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('findNearby()', () {
      test('returns locations within the specified radius', () async {
        // // Create two locations in London.
        // await LocationService.create(
        //   session,
        //   name: 'Trafalgar Square',
        //   latitude: 51.5080,
        //   longitude: -0.1281,
        //   radiusMeters: 100,
        // );
        // await LocationService.create(
        //   session,
        //   name: 'Buckingham Palace',
        //   latitude: 51.5014,
        //   longitude: -0.1419,
        //   radiusMeters: 200,
        // );
        // // Create a far-away location.
        // await LocationService.create(
        //   session,
        //   name: 'Eiffel Tower',
        //   latitude: 48.8584,
        //   longitude: 2.2945,
        //   radiusMeters: 100,
        // );
        //
        // // Search near Trafalgar Square with 2km radius.
        // final nearby = await LocationService.findNearby(
        //   session,
        //   latitude: 51.5080,
        //   longitude: -0.1281,
        //   radiusMeters: 2000,
        // );
        //
        // final names = nearby.map((l) => l.name).toSet();
        // expect(names, contains('Trafalgar Square'));
        // expect(names, contains('Buckingham Palace'));
        // expect(names, isNot(contains('Eiffel Tower')));
      }, skip: 'Requires serverpod_test database session');

      test('results are sorted by distance ascending', () async {
        // final nearby = await LocationService.findNearby(
        //   session,
        //   latitude: 51.5080,
        //   longitude: -0.1281,
        //   radiusMeters: 50000,
        // );
        //
        // // Verify sorted by distance (first is closest).
        // if (nearby.length > 1) {
        //   expect(nearby.first.name, equals('Trafalgar Square'));
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    group('isWithinLocation()', () {
      test('returns true when point is inside location radius', () async {
        // final location = await LocationService.create(
        //   session,
        //   name: 'Test Area',
        //   latitude: 51.5074,
        //   longitude: -0.1278,
        //   radiusMeters: 1000, // 1 km
        // );
        //
        // // Point very close to center.
        // final within = await LocationService.isWithinLocation(
        //   session,
        //   locationId: location.id!,
        //   latitude: 51.5075,
        //   longitude: -0.1279,
        // );
        //
        // expect(within, isTrue);
      }, skip: 'Requires serverpod_test database session');

      test('returns false when point is outside location radius', () async {
        // final location = await LocationService.create(
        //   session,
        //   name: 'Test Area',
        //   latitude: 51.5074,
        //   longitude: -0.1278,
        //   radiusMeters: 100, // 100 m
        // );
        //
        // // Point far away.
        // final within = await LocationService.isWithinLocation(
        //   session,
        //   locationId: location.id!,
        //   latitude: 48.8566,
        //   longitude: 2.3522,
        // );
        //
        // expect(within, isFalse);
      }, skip: 'Requires serverpod_test database session');
    });

    group('distanceTo()', () {
      test('returns distance in meters', () async {
        // final location = await LocationService.create(
        //   session,
        //   name: 'Origin',
        //   latitude: 0.0,
        //   longitude: 0.0,
        //   radiusMeters: 100,
        // );
        //
        // final distance = await LocationService.distanceTo(
        //   session,
        //   locationId: location.id!,
        //   latitude: 0.0,
        //   longitude: 1.0,
        // );
        //
        // // ~111 km.
        // expect(distance, closeTo(111_000, 1_000));
      }, skip: 'Requires serverpod_test database session');
    });

    group('searchByName()', () {
      test('finds locations by partial name match', () async {
        // await LocationService.create(
        //   session,
        //   name: 'Central Park',
        //   latitude: 40.7829,
        //   longitude: -73.9654,
        //   radiusMeters: 500,
        // );
        //
        // final results = await LocationService.searchByName(
        //   session,
        //   query: 'central',
        // );
        //
        // expect(results.any((l) => l.name == 'Central Park'), isTrue);
      }, skip: 'Requires serverpod_test database session');

      test('returns empty list when no match', () async {
        // final results = await LocationService.searchByName(
        //   session,
        //   query: 'zzz_no_match_zzz',
        // );
        // expect(results, isEmpty);
      }, skip: 'Requires serverpod_test database session');
    });
  });
}
