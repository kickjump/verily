import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// A themed card widget with consistent styling, press animations,
/// hover elevation for desktop, optional shimmer loading state, and entrance
/// animation support.
class VCard extends HookWidget {
  const VCard({
    required this.child,
    this.padding,
    this.onTap,
    this.margin,
    this.isLoading = false,
    this.animate = false,
    this.animationDelay = Duration.zero,
    super.key,
  });

  /// The card content.
  final Widget child;

  /// Optional inner padding applied around [child].
  final EdgeInsetsGeometry? padding;

  /// Tap callback. When set, the card responds to taps with a subtle
  /// scale-down animation (0.98×, 120 ms) and hover with elevated shadow.
  final VoidCallback? onTap;

  /// Optional outer margin.
  final EdgeInsetsGeometry? margin;

  /// When `true` the card content is replaced with a shimmer skeleton
  /// placeholder, useful while data is being fetched.
  final bool isLoading;

  /// When `true` the card plays a fade-in + slide-up entrance animation
  /// on first build.
  final bool animate;

  /// Delay before the entrance animation starts. Useful for staggering
  /// multiple cards in a list.
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final radius = BorderRadius.circular(RadiusTokens.lg);

    // --- press scale animation ---
    final scaleController = useAnimationController(
      duration: const Duration(milliseconds: 120),
    );
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1, end: 0.98).animate(
        CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
      ),
    );

    // --- hover state for desktop/web elevation boost ---
    final isHovered = useState(false);

    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    // Shadow intensifies on hover for interactive cards.
    final hovered = isHovered.value && onTap != null;
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
          color: Colors.black.withValues(
            alpha: isLight ? (hovered ? 0.12 : 0.08) : (hovered ? 0.32 : 0.24),
          ),
          blurRadius: hovered ? 26 : 18,
          offset: Offset(0, hovered ? 12 : 10),
        ),
      ],
    );

    // --- shimmer loading state ---
    final Widget displayChild;
    if (isLoading) {
      displayChild = _ShimmerSkeleton(radius: radius, isLight: isLight);
    } else {
      displayChild = content;
    }

    final decoratedCard = Transform.scale(
      scale: onTap != null ? scaleAnimation : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: onTap == null
              ? displayChild
              : MouseRegion(
                  onEnter: (_) => isHovered.value = true,
                  onExit: (_) => isHovered.value = false,
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTapDown: (_) => scaleController.forward(),
                    onTapUp: (_) {
                      scaleController.reverse();
                      onTap?.call();
                    },
                    onTapCancel: scaleController.reverse,
                    behavior: HitTestBehavior.opaque,
                    child: displayChild,
                  ),
                ),
        ),
      ),
    );

    Widget result = decoratedCard;

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    // --- entrance animation ---
    if (animate) {
      result = result
          .animate(delay: animationDelay)
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.04, end: 0, duration: 400.ms, curve: Curves.easeOut);
    }

    return result;
  }
}

/// Internal shimmer skeleton shown when [VCard.isLoading] is `true`.
class _ShimmerSkeleton extends StatelessWidget {
  const _ShimmerSkeleton({required this.radius, required this.isLight});

  final BorderRadius radius;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final baseColor = isLight
        ? const Color(0xFFE8EDF5)
        : const Color(0xFF1E3052);
    final highlightColor = isLight
        ? const Color(0xFFF5F8FF)
        : const Color(0xFF2A4470);

    return Padding(
          padding: const EdgeInsets.all(SpacingTokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title placeholder
              Container(
                height: 14,
                width: 140,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
              ),
              const SizedBox(height: SpacingTokens.sm),
              // Subtitle placeholder
              Container(
                height: 10,
                width: 200,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
              ),
              const SizedBox(height: SpacingTokens.md),
              // Body placeholder
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: highlightColor.withValues(alpha: 0.6),
        );
  }
}
