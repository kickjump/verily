import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/generated/protocol.dart';

/// Server-side proxy for the Mapbox Geocoding v6 API.
///
/// The Mapbox access token is read from `passwords.yaml` under the key
/// `mapboxAccessToken`. If the token is missing, methods return empty results
/// gracefully instead of throwing.
class MapboxGeocodingService {
  MapboxGeocodingService._();

  static final _log = VLogger('MapboxGeocodingService');

  static const _baseUrl = 'https://api.mapbox.com/search/geocode/v6';

  /// Searches for places matching [query].
  ///
  /// Optionally biases results toward [proximityLat]/[proximityLng].
  static Future<List<PlaceSearchResult>> searchPlaces(
    Session session,
    String query, {
    double? proximityLat,
    double? proximityLng,
    int limit = 5,
  }) async {
    final token = session.passwords['mapboxAccessToken'];
    if (token == null || token.isEmpty) {
      _log.warning('mapboxAccessToken not configured in passwords.yaml');
      return [];
    }

    final params = <String, String>{
      'q': query,
      'access_token': token,
      'limit': limit.toString(),
    };

    if (proximityLat != null && proximityLng != null) {
      params['proximity'] = '$proximityLng,$proximityLat';
    }

    final uri = Uri.parse('$_baseUrl/forward').replace(queryParameters: params);

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        _log.warning(
          'Mapbox geocoding failed: ${response.statusCode} ${response.body}',
        );
        return [];
      }

      return _parseFeatures(response.body);
    } on Exception catch (e) {
      _log.warning('Mapbox geocoding error: $e');
      return [];
    }
  }

  /// Reverse-geocodes a coordinate to the nearest place.
  static Future<PlaceSearchResult?> reverseGeocode(
    Session session,
    double latitude,
    double longitude,
  ) async {
    final token = session.passwords['mapboxAccessToken'];
    if (token == null || token.isEmpty) {
      _log.warning('mapboxAccessToken not configured in passwords.yaml');
      return null;
    }

    final params = <String, String>{'access_token': token, 'limit': '1'};

    final uri = Uri.parse('$_baseUrl/reverse').replace(
      queryParameters: {
        ...params,
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        _log.warning(
          'Mapbox reverse geocoding failed: '
          '${response.statusCode} ${response.body}',
        );
        return null;
      }

      final results = _parseFeatures(response.body);
      return results.isEmpty ? null : results.first;
    } on Exception catch (e) {
      _log.warning('Mapbox reverse geocoding error: $e');
      return null;
    }
  }

  /// Parses the Mapbox Geocoding v6 GeoJSON response into
  /// [PlaceSearchResult] instances.
  static List<PlaceSearchResult> _parseFeatures(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final features = json['features'] as List<dynamic>? ?? [];

    return features.map((feature) {
      final f = feature as Map<String, dynamic>;
      final properties = f['properties'] as Map<String, dynamic>? ?? {};
      final geometry = f['geometry'] as Map<String, dynamic>? ?? {};
      final coordinates = geometry['coordinates'] as List<dynamic>? ?? [0, 0];

      return PlaceSearchResult(
        mapboxId: (properties['mapbox_id'] as String?) ?? '',
        name: (properties['name'] as String?) ?? '',
        fullAddress: properties['full_address'] as String?,
        latitude: (coordinates[1] as num).toDouble(),
        longitude: (coordinates[0] as num).toDouble(),
        category: properties['feature_type'] as String?,
      );
    }).toList();
  }
}
