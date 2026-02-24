import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/mapbox_geocoding_service.dart';

/// Endpoint for geocoding operations using Mapbox.
///
/// Acts as a server-side proxy so that the Mapbox access token is never
/// exposed to the Flutter client. All methods require authentication.
class GeocodingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Searches for places matching [query].
  ///
  /// Optionally biases results toward [proximityLat]/[proximityLng] when
  /// provided.
  Future<List<PlaceSearchResult>> searchPlaces(
    Session session,
    String query,
    double? proximityLat,
    double? proximityLng,
  ) async {
    return MapboxGeocodingService.searchPlaces(
      session,
      query,
      proximityLat: proximityLat,
      proximityLng: proximityLng,
    );
  }

  /// Reverse-geocodes a coordinate to the nearest place.
  Future<PlaceSearchResult?> reverseGeocode(
    Session session,
    double lat,
    double lng,
  ) async {
    return MapboxGeocodingService.reverseGeocode(session, lat, lng);
  }
}
