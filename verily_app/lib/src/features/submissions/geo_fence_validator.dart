import 'dart:math' as math;

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
/// Uses the Haversine formula for accurate great-circle distance calculation.
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

  final distance = _haversineDistance(userLat, userLng, actionLat, actionLng);

  return GeoFenceResult(
    isWithinFence: distance <= radius,
    distanceMeters: distance,
    radiusMeters: radius,
  );
}

/// Haversine distance in meters between two geographic coordinates.
double _haversineDistance(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371000.0;
  final dLat = _toRadians(lat2 - lat1);
  final dLng = _toRadians(lng2 - lng1);
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _toRadians(double degrees) => degrees * math.pi / 180;
