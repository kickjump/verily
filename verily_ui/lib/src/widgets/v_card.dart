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
    final isLight = theme.brightness == Brightness.light;
    final radius = BorderRadius.circular(RadiusTokens.lg);

    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    final decoration = BoxDecoration(
      borderRadius: radius,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isLight
            ? [
                Colors.white.withValues(alpha: 0.98),
                const Color(0xFFF4F8FF).withValues(alpha: 0.96),
              ]
            : [
                const Color(0xFF182947).withValues(alpha: 0.95),
                const Color(0xFF0F1B34).withValues(alpha: 0.94),
              ],
      ),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.8),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.24),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );

    final decoratedCard = DecoratedBox(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: radius, child: content),
      ),
    );

    if (margin == null) {
      return decoratedCard;
    }
    return Padding(padding: margin!, child: decoratedCard);
  }
}
