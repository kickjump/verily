import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_ui/src/theme/color_tokens.dart';

/// Result returned when a location is confirmed in the picker.
class LocationPickerResult {
  const LocationPickerResult({
    required this.point,
    required this.radiusMeters,
    this.name,
    this.address,
  });

  final GeoPoint point;
  final String? name;
  final String? address;
  final double radiusMeters;
}

/// An embedded map widget for picking a location.
///
/// The map has a fixed center pin (like Uber pickup). Dragging the map
/// repositions the pin. A radius circle overlay shows the verification area.
///
/// Call [onConfirm] to receive the selected [LocationPickerResult].
class LocationPickerMap extends HookWidget {
  const LocationPickerMap({
    this.initialCenter,
    this.initialRadius = 200,
    this.onConfirm,
    this.onCenterChanged,
    super.key,
  });

  /// Initial map center. Defaults to San Francisco.
  final LatLng? initialCenter;

  /// Initial radius in meters.
  final double initialRadius;

  /// Called when the user confirms the selected location.
  final ValueChanged<LocationPickerResult>? onConfirm;

  /// Called when the map center changes (on drag end).
  final ValueChanged<LatLng>? onCenterChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mapController = useMemoized(MapController.new);
    final center = useState(initialCenter ?? const LatLng(37.7749, -122.4194));
    final radius = useState(initialRadius);

    void onMapEvent(MapEvent event) {
      if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
        center.value = mapController.camera.center;
        onCenterChanged?.call(center.value);
      }
    }

    return Column(
      children: [
        // Map
        SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: center.value,
                    initialZoom: 15,
                    onMapEvent: onMapEvent,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'fun.verily.app',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: center.value,
                          radius: radius.value,
                          useRadiusInMeter: true,
                          color: ColorTokens.primary.withAlpha(25),
                          borderColor: ColorTokens.primary.withAlpha(100),
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                // Fixed center pin
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 36),
                    child: Icon(
                      Icons.location_pin,
                      size: 48,
                      color: ColorTokens.primary,
                    ),
                  ),
                ),
                // Pin shadow
                Center(
                  child: Container(
                    width: 8,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Radius slider
        Row(
          children: [
            Text(
              'Radius',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Slider(
                value: radius.value,
                min: 50,
                max: 5000,
                divisions: 99,
                activeColor: ColorTokens.primary,
                onChanged: (v) => radius.value = v,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                radius.value >= 1000
                    ? '${(radius.value / 1000).toStringAsFixed(1)} km'
                    : '${radius.value.round()} m',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorTokens.primary,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Confirm button
        if (onConfirm != null)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                onConfirm!(
                  LocationPickerResult(
                    point: GeoPoint(
                      latitude: center.value.latitude,
                      longitude: center.value.longitude,
                    ),
                    radiusMeters: radius.value,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Confirm Location'),
              style: FilledButton.styleFrom(
                backgroundColor: ColorTokens.primary,
              ),
            ),
          ),
      ],
    );
  }
}
