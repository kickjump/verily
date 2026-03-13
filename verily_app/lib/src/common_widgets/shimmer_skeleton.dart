import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/verily_ui.dart';

/// A single shimmer placeholder block with rounded corners.
///
/// Used as a building block for skeleton loading states.
class ShimmerBlock extends HookWidget {
  const ShimmerBlock({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(
              borderRadius ?? RadiusTokens.sm,
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          delay: 200.ms,
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.7),
        );
  }
}

/// Skeleton for a featured action card in the horizontal carousel.
class ShimmerFeaturedCard extends HookWidget {
  const ShimmerFeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : ColorTokens.primary.withValues(alpha: 0.08);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: glassBorderColor),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBlock(
            width: double.infinity,
            height: 36,
            borderRadius: RadiusTokens.md,
          ),
          SizedBox(height: SpacingTokens.sm),
          Row(
            children: [
              ShimmerBlock(width: 60, height: 22),
              Spacer(),
              ShimmerBlock(width: 50, height: 16),
            ],
          ),
          SizedBox(height: SpacingTokens.md),
          ShimmerBlock(width: 200, height: 18),
          SizedBox(height: SpacingTokens.sm),
          ShimmerBlock(width: 140, height: 18),
          Spacer(),
          Row(
            children: [
              ShimmerBlock(width: 100, height: 20),
              Spacer(),
              ShimmerBlock(width: 60, height: 32),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton for an action list item row.
class ShimmerActionListItem extends HookWidget {
  const ShimmerActionListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : ColorTokens.primary.withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.lg,
        0,
        SpacingTokens.lg,
        SpacingTokens.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: Border.all(color: glassBorderColor),
        ),
        child: const Row(
          children: [
            ShimmerBlock(width: 44, height: 44),
            SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBlock(width: 160, height: 16),
                  SizedBox(height: SpacingTokens.sm),
                  ShimmerBlock(width: 100, height: 12),
                ],
              ),
            ),
            SizedBox(width: SpacingTokens.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerBlock(width: 50, height: 20),
                SizedBox(height: SpacingTokens.xs),
                ShimmerBlock(width: 70, height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the action detail screen while loading.
class ShimmerActionDetail extends HookWidget {
  const ShimmerActionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          const Row(
            children: [
              ShimmerBlock(width: 80, height: 26),
              SizedBox(width: SpacingTokens.sm),
              ShimmerBlock(width: 60, height: 26),
              Spacer(),
              ShimmerBlock(width: 70, height: 26),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          // Title
          const ShimmerBlock(width: 280, height: 28),
          const SizedBox(height: SpacingTokens.sm),
          const ShimmerBlock(width: 220, height: 28),
          const SizedBox(height: SpacingTokens.sm),
          // Description
          const ShimmerBlock(width: double.infinity, height: 16),
          const SizedBox(height: SpacingTokens.xs),
          const ShimmerBlock(width: double.infinity, height: 16),
          const SizedBox(height: SpacingTokens.xs),
          const ShimmerBlock(width: 200, height: 16),
          const SizedBox(height: SpacingTokens.lg),
          // Section header
          const ShimmerBlock(width: 180, height: 20),
          const SizedBox(height: SpacingTokens.sm),
          // Criteria card
          _buildShimmerCard(context, childCount: 3),
          const SizedBox(height: SpacingTokens.lg),
          // Metadata card
          const ShimmerBlock(width: 120, height: 20),
          const SizedBox(height: SpacingTokens.sm),
          _buildShimmerCard(context, childCount: 4),
        ],
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, {required int childCount}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : ColorTokens.primary.withValues(alpha: 0.08);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: glassBorderColor),
      ),
      child: Column(
        children: List.generate(childCount, (i) {
          return Padding(
            padding: EdgeInsets.only(top: i > 0 ? SpacingTokens.sm : 0),
            child: const Row(
              children: [
                ShimmerBlock(width: 18, height: 18),
                SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: ShimmerBlock(width: double.infinity, height: 14),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Skeleton for the wallet balance area.
class ShimmerWalletBalance extends HookWidget {
  const ShimmerWalletBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [ShimmerBlock(width: 180, height: 36)]);
  }
}

/// Skeleton for the wallet list while loading.
class ShimmerWalletList extends HookWidget {
  const ShimmerWalletList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : ColorTokens.primary.withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      child: Column(
        children: List.generate(2, (i) {
          return Padding(
            padding: EdgeInsets.only(top: i > 0 ? SpacingTokens.sm : 0),
            child: Container(
              padding: const EdgeInsets.all(SpacingTokens.md),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(RadiusTokens.md),
                border: Border.all(color: glassBorderColor),
              ),
              child: const Row(
                children: [
                  ShimmerBlock(width: 40, height: 40),
                  SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBlock(width: 100, height: 16),
                        SizedBox(height: SpacingTokens.xs),
                        ShimmerBlock(width: 80, height: 12),
                      ],
                    ),
                  ),
                  ShimmerBlock(width: 60, height: 14),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
