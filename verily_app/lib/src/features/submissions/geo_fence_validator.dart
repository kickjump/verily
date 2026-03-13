import 'package:geolocator/geolocator.dart';

/// Result of a geo-fence validation check.
class GeoFenceResult {
  const GeoFenceResult({
    required this.isWithinFence,
    required this.distanceMeters,
    required this.radiusMeters,
  });

  /// Whether the user's position is within the geo-fence.
  final bool isWithinFence;

  /// Distance in meters from the user's position to the geo-fence center.
  final double distanceMeters;

  /// The required radius in meters.
  final double radiusMeters;

  /// How far outside the fence the user is (0 if inside).
  double get overshootMeters =>
      isWithinFence ? 0 : distanceMeters - radiusMeters;

  /// Human-readable distance string.
  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  }

  /// Human-readable overshoot string.
  String get formattedOvershoot {
    final overshoot = overshootMeters;
    if (overshoot < 1000) {
      return '${overshoot.round()} m';
    }
    return '${(overshoot / 1000).toStringAsFixed(1)} km';
  }
}

/// Validates whether the user's GPS position falls within a geo-fence
/// defined by a center point and radius.
///
/// Uses the Haversine formula via [Geolocator.distanceBetween] for accurate
/// great-circle distance calculation.
///
/// Returns `null` if there is no location requirement (both [actionLat] and
/// [actionLng] must be non-null for validation to occur).
GeoFenceResult? validateGeoFence({
  required double? userLat,
  required double? userLng,
  required double? actionLat,
  required double? actionLng,
  required double? radiusMeters,
}) {
  // No geo-fence check if the action has no location requirement.
  if (actionLat == null || actionLng == null) return null;

  // Can't validate without user position.
  if (userLat == null || userLng == null) return null;

  // Default to 200m radius if not specified.
  final radius = radiusMeters ?? 200.0;

  final distance = Geolocator.distanceBetween(
    userLat,
    userLng,
    actionLat,
    actionLng,
  );

  return GeoFenceResult(
    isWithinFence: distance <= radius,
    distanceMeters: distance,
    radiusMeters: radius,
  );
}
