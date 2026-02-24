import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/map/providers/geocoding_providers.dart';
import 'package:verily_ui/verily_ui.dart';

/// Search bar that queries the Mapbox geocoding endpoint with debouncing.
///
/// Displays autocomplete suggestions in a dropdown. When a place is selected,
/// calls [onPlaceSelected] with the coordinates and name.
class LocationSearchWidget extends HookConsumerWidget {
  const LocationSearchWidget({required this.onPlaceSelected, super.key});

  final void Function(double lat, double lng, String name) onPlaceSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final query = useState('');
    final isExpanded = useState(false);
    final debounceTimer = useRef<Timer?>(null);

    void onChanged(String value) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 300), () {
        query.value = value;
      });
    }

    // Cancel timer on dispose.
    useEffect(() {
      return () => debounceTimer.value?.cancel();
    }, const []);

    final searchResults = query.value.length >= 2
        ? ref.watch(placeSearchProvider(query.value, null, null))
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () => isExpanded.value = true,
          decoration: InputDecoration(
            hintText: 'Search places...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      controller.clear();
                      query.value = '';
                      isExpanded.value = false;
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.sm,
              vertical: SpacingTokens.sm,
            ),
          ),
        ),
        if (isExpanded.value && searchResults != null)
          searchResults.when(
            data: (results) {
              if (results.isEmpty) return const SizedBox.shrink();
              return Material(
                elevation: ElevationTokens.med,
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final place = results[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined, size: 20),
                      title: Text(place.name),
                      subtitle: place.fullAddress != null
                          ? Text(
                              place.fullAddress!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      onTap: () {
                        controller.text = place.name;
                        isExpanded.value = false;
                        onPlaceSelected(
                          place.latitude,
                          place.longitude,
                          place.name,
                        );
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(SpacingTokens.md),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}
