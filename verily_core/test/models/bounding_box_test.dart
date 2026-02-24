import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('BoundingBox', () {
    test('creates with required fields', () {
      const bbox = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      expect(bbox.southLat, 37.7);
      expect(bbox.westLng, -122.5);
      expect(bbox.northLat, 37.8);
      expect(bbox.eastLng, -122.4);
    });

    test('serializes to and from JSON', () {
      const bbox = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      final json = bbox.toJson();
      final restored = BoundingBox.fromJson(json);

      expect(restored.southLat, bbox.southLat);
      expect(restored.westLng, bbox.westLng);
      expect(restored.northLat, bbox.northLat);
      expect(restored.eastLng, bbox.eastLng);
    });

    test('JSON contains expected keys', () {
      const bbox = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      final json = bbox.toJson();

      expect(json, containsPair('southLat', 37.7));
      expect(json, containsPair('westLng', -122.5));
      expect(json, containsPair('northLat', 37.8));
      expect(json, containsPair('eastLng', -122.4));
    });

    test('equality works for identical values', () {
      const a = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );
      const b = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('inequality works for different values', () {
      const a = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );
      const b = BoundingBox(
        southLat: 40.7,
        westLng: -74,
        northLat: 40.8,
        eastLng: -73.9,
      );

      expect(a, isNot(equals(b)));
    });

    test('handles negative and positive coordinates', () {
      const bbox = BoundingBox(
        southLat: -33.9,
        westLng: 18.4,
        northLat: -33.8,
        eastLng: 18.5,
      );

      expect(bbox.southLat, -33.9);
      expect(bbox.westLng, 18.4);
    });

    test('handles zero coordinates', () {
      const bbox = BoundingBox(
        southLat: 0,
        westLng: 0,
        northLat: 0,
        eastLng: 0,
      );

      expect(bbox.southLat, 0);
      expect(bbox.westLng, 0);
      expect(bbox.northLat, 0);
      expect(bbox.eastLng, 0);
    });

    test('copyWith creates modified copy', () {
      const original = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      final modified = original.copyWith(southLat: 37.6);

      expect(modified.southLat, 37.6);
      expect(modified.westLng, original.westLng);
      expect(modified.northLat, original.northLat);
      expect(modified.eastLng, original.eastLng);
    });

    test('copyWith with no changes returns equal object', () {
      const original = BoundingBox(
        southLat: 37.7,
        westLng: -122.5,
        northLat: 37.8,
        eastLng: -122.4,
      );

      final copy = original.copyWith();

      expect(copy, equals(original));
    });
  });
}
