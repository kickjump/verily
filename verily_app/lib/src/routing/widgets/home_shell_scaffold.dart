import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Root shell with bottom tabs and center verification action.
class HomeShellScaffold extends HookWidget {
  const HomeShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    void goToBranch(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF050B19)
          : const Color(0xFFE8EEFF),
      extendBody: true,
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDark
                  ? GradientTokens.shellBackground
                  : GradientTokens.shellBackgroundLight,
            ),
            child: const SizedBox.expand(),
          ),
          if (isDark) ...[
            const Positioned(
              top: -140,
              right: -120,
              child: _AmbientGlow(
                size: 280,
                colors: [Color(0xAA1F6CFF), Color(0x002B59FF)],
                pulseDuration: Duration(milliseconds: 4200),
                floatDuration: Duration(milliseconds: 6400),
                floatOffset: 14,
              ),
            ),
            const Positioned(
              bottom: 180,
              left: -90,
              child: _AmbientGlow(
                size: 220,
                colors: [Color(0x66FFD447), Color(0x00FFD447)],
                pulseDuration: Duration(milliseconds: 3600),
                floatDuration: Duration(milliseconds: 5800),
                floatOffset: 10,
              ),
            ),
            const Positioned(
              top: 120,
              left: -120,
              child: _AmbientGlow(
                size: 260,
                colors: [Color(0x4448FFE3), Color(0x0048FFE3)],
                pulseDuration: Duration(milliseconds: 5000),
                floatDuration: Duration(milliseconds: 7200),
                floatOffset: 16,
              ),
            ),
          ] else ...[
            const Positioned(
              top: -140,
              right: -120,
              child: _AmbientGlow(
                size: 280,
                colors: [Color(0x441F6CFF), Color(0x002B59FF)],
                pulseDuration: Duration(milliseconds: 4200),
                floatDuration: Duration(milliseconds: 6400),
                floatOffset: 10,
              ),
            ),
            const Positioned(
              bottom: 180,
              left: -90,
              child: _AmbientGlow(
                size: 220,
                colors: [Color(0x33FFD447), Color(0x00FFD447)],
                pulseDuration: Duration(milliseconds: 3600),
                floatDuration: Duration(milliseconds: 5800),
                floatOffset: 8,
              ),
            ),
          ],
          navigationShell,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _AnimatedFab(isDark: isDark, theme: theme),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          SpacingTokens.md,
          0,
          SpacingTokens.md,
          SpacingTokens.md,
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 16,
          color: colorScheme.surfaceContainer.withValues(alpha: 0.92),
          child: SizedBox(
            height: 76,
            child: Row(
              children: [
                Expanded(
                  child: _BottomItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: AppLocalizations.of(context).homeTitle,
                    selected: navigationShell.currentIndex == 0,
                    onTap: () => goToBranch(0),
                  ),
                ),
                Expanded(
                  child: _BottomItem(
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: AppLocalizations.of(context).searchTitle,
                    selected: navigationShell.currentIndex == 1,
                    onTap: () => goToBranch(1),
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: _BottomItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: AppLocalizations.of(context).profileTitle,
                    selected: navigationShell.currentIndex == 2,
                    onTap: () => goToBranch(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFab extends HookWidget {
  const _AnimatedFab({required this.isDark, required this.theme});

  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Pulsing glow animation for the shadow
    final glowController = useAnimationController(
      duration: const Duration(milliseconds: 2400),
    );
    final glowAnimation = useAnimation(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );

    useEffect(() {
      glowController.repeat(reverse: true);
      return null;
    }, const []);

    // Shadow pulse: blur oscillates 20–36, opacity oscillates via color alpha
    final glowBlur = 20.0 + 16.0 * glowAnimation;
    final glowAlpha = (0.35 + 0.25 * glowAnimation).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.sm,
                vertical: SpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.32)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : ColorTokens.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).appVerify,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.94)
                      : ColorTokens.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.3,
              end: 0,
              duration: 500.ms,
              delay: 200.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: SpacingTokens.xs),
        DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                gradient: GradientTokens.accentPill,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(255, 205, 58, glowAlpha),
                    blurRadius: glowBlur,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FloatingActionButton(
                key: const Key('homeShell_verifyFab'),
                tooltip: AppLocalizations.of(
                  context,
                ).navigationOpenVerificationCapture,
                onPressed: () => context.push(RouteNames.verifyCapturePath),
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: const Color(0xFF111318),
                child: const Icon(Icons.videocam_rounded),
              ),
            )
            .animate()
            .scaleXY(
              begin: 0,
              end: 1,
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),
      ],
    );
  }
}

class _BottomItem extends HookWidget {
  const _BottomItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurfaceVariant;

    // Scale + fade animation on selection change
    final scaleController = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );
    final scaleAnimation = useAnimation(
      CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
    );

    // Track previous selected state to trigger animation
    final previousSelected = usePrevious(selected);
    useEffect(() {
      if (selected && !(previousSelected ?? false)) {
        // Just became selected — play bounce-in
        scaleController
          ..reset()
          ..forward();
      } else if (selected) {
        // Already selected on first build
        scaleController.value = 1.0;
      }
      return null;
    }, [selected]);

    // Icon scale: unselected=1.0, selected animates 0.7 → 1.15 → 1.0
    final iconScale = selected ? (0.7 + 0.45 * scaleAnimation) : 1.0;
    // Label opacity: unselected=0.7, selected animates to 1.0
    final labelOpacity = selected ? (0.7 + 0.3 * scaleAnimation) : 0.7;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: iconScale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected
                      ? activeColor.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Icon(
                    selected ? activeIcon : icon,
                    key: ValueKey(selected),
                    color: selected ? activeColor : inactiveColor,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style:
                  theme.textTheme.labelSmall?.copyWith(
                    color: (selected ? activeColor : inactiveColor).withValues(
                      alpha: labelOpacity,
                    ),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11,
                    height: 1,
                  ) ??
                  const TextStyle(),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends HookWidget {
  const _AmbientGlow({
    required this.size,
    required this.colors,
    this.floatOffset = 12,
    this.pulseDuration = const Duration(seconds: 4),
    this.floatDuration = const Duration(seconds: 6),
  });

  final double size;
  final List<Color> colors;

  /// Maximum pixel offset for the floating movement.
  final double floatOffset;

  /// Duration for a full opacity pulse cycle.
  final Duration pulseDuration;

  /// Duration for a full floating translate cycle.
  final Duration floatDuration;

  @override
  Widget build(BuildContext context) {
    // Opacity pulse animation
    final pulseController = useAnimationController(duration: pulseDuration);
    final pulseAnimation = useAnimation(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    // Floating vertical movement animation
    final floatController = useAnimationController(duration: floatDuration);
    final floatAnimation = useAnimation(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    useEffect(() {
      pulseController.repeat(reverse: true);
      floatController.repeat(reverse: true);
      return null;
    }, const []);

    // Opacity oscillates between 0.6 and 1.0
    final opacity = 0.6 + 0.4 * pulseAnimation;
    // Translate oscillates between -floatOffset and +floatOffset
    final dy = (floatAnimation * 2 - 1) * floatOffset;

    return IgnorePointer(
      child: Transform.translate(
        offset: Offset(0, dy),
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: colors),
            ),
          ),
        ),
      ),
    );
  }
}
