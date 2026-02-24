// NOTE: This test file requires freezed code generation to have been run.
// Run `dart run build_runner build` in the verily_core package before
// executing these tests.

import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('GeoPoint', () {
    group('construction', () {
      test('creates instance with latitude and longitude', () {
        const point = GeoPoint(latitude: 37.7749, longitude: -122.4194);

        expect(point.latitude, equals(37.7749));
        expect(point.longitude, equals(-122.4194));
      });

      test('creates instance with zero coordinates', () {
        const point = GeoPoint(latitude: 0, longitude: 0);

        expect(point.latitude, equals(0.0));
        expect(point.longitude, equals(0.0));
      });

      test('creates instance with negative coordinates', () {
        const point = GeoPoint(latitude: -33.8688, longitude: 151.2093);

        expect(point.latitude, equals(-33.8688));
        expect(point.longitude, equals(151.2093));
      });

      test('creates instance with extreme latitude values', () {
        const northPole = GeoPoint(latitude: 90, longitude: 0);
        const southPole = GeoPoint(latitude: -90, longitude: 0);

        expect(northPole.latitude, equals(90.0));
        expect(southPole.latitude, equals(-90.0));
      });

      test('creates instance with extreme longitude values', () {
        const east = GeoPoint(latitude: 0, longitude: 180);
        const west = GeoPoint(latitude: 0, longitude: -180);

        expect(east.longitude, equals(180.0));
        expect(west.longitude, equals(-180.0));
      });
    });

    group('field access', () {
      test('latitude returns correct value', () {
        const point = GeoPoint(latitude: 51.5074, longitude: -0.1278);
        expect(point.latitude, equals(51.5074));
      });

      test('longitude returns correct value', () {
        const point = GeoPoint(latitude: 51.5074, longitude: -0.1278);
        expect(point.longitude, equals(-0.1278));
      });
    });

    group('equality', () {
      test('two points with same coordinates are equal', () {
        const point1 = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        const point2 = GeoPoint(latitude: 37.7749, longitude: -122.4194);

        expect(point1, equals(point2));
      });

      test('two equal points have same hashCode', () {
        const point1 = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        const point2 = GeoPoint(latitude: 37.7749, longitude: -122.4194);

        expect(point1.hashCode, equals(point2.hashCode));
      });

      test('points with different latitudes are not equal', () {
        const point1 = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        const point2 = GeoPoint(latitude: 38, longitude: -122.4194);

        expect(point1, isNot(equals(point2)));
      });

      test('points with different longitudes are not equal', () {
        const point1 = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        const point2 = GeoPoint(latitude: 37.7749, longitude: -121);

        expect(point1, isNot(equals(point2)));
      });

      test('points with completely different coordinates are not equal', () {
        const sanFrancisco = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        const london = GeoPoint(latitude: 51.5074, longitude: -0.1278);

        expect(sanFrancisco, isNot(equals(london)));
      });
    });

    group('copyWith', () {
      test('creates copy with updated latitude', () {
        const original = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        final copy = original.copyWith(latitude: 40.7128);

        expect(copy.latitude, equals(40.7128));
        expect(copy.longitude, equals(original.longitude));
      });

      test('creates copy with updated longitude', () {
        const original = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        final copy = original.copyWith(longitude: -74.0060);

        expect(copy.latitude, equals(original.latitude));
        expect(copy.longitude, equals(-74.0060));
      });

      test('creates copy with both fields updated', () {
        const original = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        final copy = original.copyWith(latitude: 48.8566, longitude: 2.3522);

        expect(copy.latitude, equals(48.8566));
        expect(copy.longitude, equals(2.3522));
      });
    });

    group('serialization', () {
      test('toJson() produces a map with latitude and longitude', () {
        const point = GeoPoint(latitude: 37.7749, longitude: -122.4194);
        final json = point.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['latitude'], equals(37.7749));
        expect(json['longitude'], equals(-122.4194));
      });

      test('fromJson() creates correct GeoPoint', () {
        final json = <String, dynamic>{
          'latitude': 51.5074,
          'longitude': -0.1278,
        };

        final point = GeoPoint.fromJson(json);

        expect(point.latitude, equals(51.5074));
        expect(point.longitude, equals(-0.1278));
      });

      test('fromJson()/toJson() round-trip produces equal object', () {
        const original = GeoPoint(latitude: -33.8688, longitude: 151.2093);
        final json = original.toJson();
        final restored = GeoPoint.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
