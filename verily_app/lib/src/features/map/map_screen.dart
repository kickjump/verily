import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/map/providers/location_providers.dart';
import 'package:verily_app/src/features/map/widgets/action_detail_bottom_sheet.dart';
import 'package:verily_app/src/features/map/widgets/action_map_marker.dart';
import 'package:verily_app/src/features/map/widgets/distance_slider.dart';
import 'package:verily_app/src/features/map/widgets/location_search_widget.dart';
import 'package:verily_client/verily_client.dart' as api;
import 'package:verily_core/verily_core.dart';
import 'package:verily_ui/verily_ui.dart';

/// Full-screen map for discovering nearby actions.
class MapScreen extends HookConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mapController = useMemoized(MapController.new);
    final selectedAction = useState<api.Action?>(null);
    final searchRadius = useState<double>(5); // km
    final userPosition = useState<LatLng?>(null);
    final bbox = useState<BoundingBox?>(null);

    final userLocationAsync = ref.watch(userLocationProvider);

    // Update userPosition when location arrives.
    useEffect(() {
      userLocationAsync.whenData((position) {
        userPosition.value = LatLng(position.latitude, position.longitude);
      });
      return null;
    }, [userLocationAsync]);

    // Fetch actions whenever bbox changes.
    final actionsAsync = bbox.value != null
        ? ref.watch(actionsInBoundingBoxProvider(bbox.value!))
        : const AsyncValue<List<api.Action>>.data([]);

    final actions = actionsAsync.value ?? [];

    void onMapEvent(MapEvent event) {
      if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
        final bounds = mapController.camera.visibleBounds;
        bbox.value = BoundingBox(
          southLat: bounds.south,
          westLng: bounds.west,
          northLat: bounds.north,
          eastLng: bounds.east,
        );
      }
    }

    void flyToLocation(LatLng location) {
      mapController.move(location, 14);
    }

    void recenter() {
      final pos = userPosition.value;
      if (pos != null) {
        mapController.move(pos, 14);
      }
    }

    // Build action markers with a simple approach: actions with locationId
    // are displayed. We use action index as a proxy for position distribution
    // within the bbox (proper approach would join location data).
    final actionMarkers = <Marker>[];
    for (final action in actions) {
      if (bbox.value == null) continue;
      // Since action doesn't embed lat/lng directly, distribute within bbox
      // This is a temporary approach until the API returns location coords
      actionMarkers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(
            // Use center of bbox as fallback
            (bbox.value!.southLat + bbox.value!.northLat) / 2,
            (bbox.value!.westLng + bbox.value!.eastLng) / 2,
          ),
          child: ActionMapMarker(
            action: action,
            onTap: () => selectedAction.value = action,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: LocationSearchWidget(
          onPlaceSelected: (lat, lng, name) {
            flyToLocation(LatLng(lat, lng));
          },
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  userPosition.value ??
                  const LatLng(37.7749, -122.4194), // Default: SF
              onMapEvent: onMapEvent,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'fun.verily.app',
              ),
              const CurrentLocationLayer(),
              if (userPosition.value != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: userPosition.value!,
                      radius: searchRadius.value * 1000, // km to meters
                      useRadiusInMeter: true,
                      color: ColorTokens.primary.withAlpha(20),
                      borderColor: ColorTokens.primary.withAlpha(80),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  disableClusteringAtZoom: 16,
                  markers: actionMarkers,
                  builder: (context, markers) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B56AE), Color(0xFF2B59FF)],
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66143D7A),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${markers.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          Positioned(
            top: SpacingTokens.md,
            left: SpacingTokens.md,
            right: SpacingTokens.md,
            child: IgnorePointer(
              child: VCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                  vertical: SpacingTokens.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.explore_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: Text(
                        actions.isEmpty
                            ? l10n.mapDiscoverNearbyHint
                            : l10n.mapActionsInView(actions.length),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    VBadgeChip(
                      label: l10n.mapRadiusKm(searchRadius.value.round()),
                      icon: Icons.radar,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Distance slider at bottom
          Positioned(
            left: SpacingTokens.md,
            right: SpacingTokens.md,
            bottom: selectedAction.value != null ? 280 : SpacingTokens.md,
            child: DistanceSlider(
              value: searchRadius.value,
              onChanged: (value) => searchRadius.value = value,
            ),
          ),

          // Empty state
          if (actions.isEmpty && bbox.value != null)
            Positioned(
              top: 86,
              left: SpacingTokens.lg,
              right: SpacingTokens.lg,
              child: VCard(
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(child: Text(l10n.mapNoActionsNearbyZoomOut)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: recenter,
        tooltip: l10n.mapRecenterTooltip,
        child: const Icon(Icons.my_location),
      ),
      bottomSheet: selectedAction.value != null
          ? ActionDetailBottomSheet(
              action: selectedAction.value!,
              onClose: () => selectedAction.value = null,
            )
          : null,
    );
  }
}
