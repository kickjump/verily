import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// A small chip widget for displaying badges, rewards, or status labels.
class VBadgeChip extends HookWidget {
  const VBadgeChip({
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bg =
        backgroundColor ??
        (theme.brightness == Brightness.light
            ? colorScheme.secondaryContainer.withValues(alpha: 0.7)
            : colorScheme.surfaceContainerHigh.withValues(alpha: 0.9));
    final fg = foregroundColor ?? colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: SpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: SpacingTokens.xs),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
