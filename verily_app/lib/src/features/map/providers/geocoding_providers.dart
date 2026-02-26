import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'geocoding_providers.g.dart';

/// Searches for places via the server-side Mapbox geocoding proxy.
@riverpod
Future<List<PlaceSearchResult>> placeSearch(
  Ref ref,
  String query,
  double? lat,
  double? lng,
) async {
  if (query.trim().isEmpty) return [];

  final client = Client(resolveServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor();
  return client.geocoding.searchPlaces(query, lat, lng);
}
