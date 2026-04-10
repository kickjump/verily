import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/demo/demo_config.dart';
import 'package:verily_client/verily_client.dart';
import 'package:verily_core/verily_core.dart';

part 'location_providers.g.dart';

/// Streams the user's current geographic position.
///
/// On web or in demo mode, emits a fixed position (demo coordinates).
/// On mobile, handles permission requests and location service checks.
@riverpod
Stream<Position> userLocation(Ref ref) async* {
  if (kIsWeb || isDemoMode) {
    yield Position(
      latitude: demoLat,
      longitude: demoLng,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    return;
  }

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission permanently denied.');
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
}

/// Fetches actions visible within a map bounding box.
@riverpod
Future<List<Action>> actionsInBoundingBox(Ref ref, BoundingBox bbox) async {
  final client = Client(resolveServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor();
  return client.action.listInBoundingBox(
    bbox.southLat,
    bbox.westLng,
    bbox.northLat,
    bbox.eastLng,
  );
}

/// Fetches actions near a geographic point within a radius.
@riverpod
Future<List<Action>> nearbyActions(
  Ref ref,
  double lat,
  double lng,
  double radiusMeters,
) async {
  final client = Client(resolveServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor();
  return client.action.listNearby(lat, lng, radiusMeters);
}
