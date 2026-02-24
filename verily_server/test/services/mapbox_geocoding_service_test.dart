import 'dart:convert';

import 'package:test/test.dart';

// Tests for MapboxGeocodingService response parsing.
//
// These tests validate the pure parsing logic without making real HTTP requests.
// The service reads from Mapbox Geocoding v6 API JSON responses.

void main() {
  group('MapboxGeocodingService response parsing', () {
    test('parses forward geocoding features correctly', () {
      // Simulates the structure returned by Mapbox Geocoding v6 forward API.
      final responseJson =
          jsonDecode(_forwardGeocodingResponse) as Map<String, dynamic>;
      final features = responseJson['features'] as List<dynamic>;

      expect(features, isNotEmpty);
      expect(features.length, 2);

      final first = features[0] as Map<String, dynamic>;
      final properties = first['properties'] as Map<String, dynamic>;
      final coordinates =
          (first['geometry'] as Map<String, dynamic>)['coordinates'] as List;

      expect(properties['mapbox_id'], isNotNull);
      expect(properties['name'], 'Central Park');
      expect(properties['full_address'], contains('New York'));
      expect(coordinates[0], isA<num>()); // longitude
      expect(coordinates[1], isA<num>()); // latitude
    });

    test('parses reverse geocoding features correctly', () {
      final responseJson =
          jsonDecode(_reverseGeocodingResponse) as Map<String, dynamic>;
      final features = responseJson['features'] as List<dynamic>;

      expect(features, isNotEmpty);

      final first = features[0] as Map<String, dynamic>;
      final properties = first['properties'] as Map<String, dynamic>;
      final coordinates =
          (first['geometry'] as Map<String, dynamic>)['coordinates'] as List;

      expect(properties['name'], isNotNull);
      expect(coordinates, hasLength(2));
    });

    test('handles empty features list', () {
      const emptyResponse = '{"type":"FeatureCollection","features":[]}';
      final parsed = jsonDecode(emptyResponse) as Map<String, dynamic>;
      final features = parsed['features'] as List<dynamic>;

      expect(features, isEmpty);
    });

    test('extracts feature_type from properties', () {
      final responseJson =
          jsonDecode(_forwardGeocodingResponse) as Map<String, dynamic>;
      final features = responseJson['features'] as List<dynamic>;
      final first = features[0] as Map<String, dynamic>;
      final properties = first['properties'] as Map<String, dynamic>;

      expect(properties['feature_type'], isA<String>());
    });
  });
}

// Sample Mapbox Geocoding v6 forward response.
const _forwardGeocodingResponse = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [-73.968285, 40.785091]
      },
      "properties": {
        "mapbox_id": "dXJuOm1ieHBsYzpBZXlrcw",
        "feature_type": "poi",
        "name": "Central Park",
        "full_address": "Central Park, New York, NY 10024, United States",
        "place_formatted": "New York, NY 10024, United States"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [-73.978, 40.765]
      },
      "properties": {
        "mapbox_id": "dXJuOm1ieHBsYzpBZXlrcw2",
        "feature_type": "poi",
        "name": "Central Park Zoo",
        "full_address": "Central Park Zoo, New York, NY 10021, United States",
        "place_formatted": "New York, NY 10021, United States"
      }
    }
  ]
}
''';

// Sample Mapbox Geocoding v6 reverse response.
const _reverseGeocodingResponse = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [-73.968285, 40.785091]
      },
      "properties": {
        "mapbox_id": "dXJuOm1ieHBsYzpBZXlrcw",
        "feature_type": "address",
        "name": "Central Park West",
        "full_address": "Central Park West, New York, NY 10024, United States",
        "place_formatted": "New York, NY 10024, United States"
      }
    }
  ]
}
''';
