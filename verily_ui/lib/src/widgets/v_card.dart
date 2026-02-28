import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// A themed card widget with consistent styling.
class VCard extends HookWidget {
  const VCard({
    required this.child,
    this.padding,
    this.onTap,
    this.margin,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    final card = Material(
      color: theme.brightness == Brightness.light
          ? Colors.white.withValues(alpha: 0.9)
          : colorScheme.surfaceContainerLow.withValues(alpha: 0.92),
      elevation: ElevationTokens.low,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.85),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    final tappableCard = onTap == null
        ? card
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            child: card,
          );

    if (margin == null) {
      return tappableCard;
    }
    return Padding(padding: margin!, child: tappableCard);
  }
}
