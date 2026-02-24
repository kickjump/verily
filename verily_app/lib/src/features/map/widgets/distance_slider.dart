import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/verily_ui.dart';

/// A horizontal slider for adjusting the search radius (1–50 km).
///
/// Displays the current radius value as a label.
class DistanceSlider extends HookWidget {
  const DistanceSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Current radius in kilometers.
  final double value;

  /// Called when the slider value changes.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: ElevationTokens.med,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.radar, size: 20, color: ColorTokens.primary),
            const SizedBox(width: SpacingTokens.sm),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: ColorTokens.primary,
                  thumbColor: ColorTokens.primary,
                  overlayColor: ColorTokens.primary.withAlpha(30),
                  inactiveTrackColor: theme.colorScheme.onSurfaceVariant
                      .withAlpha(40),
                ),
                child: Slider(
                  value: value,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '${value.round()} km',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorTokens.primary,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
