import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
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
              ),
            ),
            const Positioned(
              bottom: 180,
              left: -90,
              child: _AmbientGlow(
                size: 220,
                colors: [Color(0x66FFD447), Color(0x00FFD447)],
              ),
            ),
            const Positioned(
              top: 120,
              left: -120,
              child: _AmbientGlow(
                size: 260,
                colors: [Color(0x4448FFE3), Color(0x0048FFE3)],
              ),
            ),
          ] else ...[
            const Positioned(
              top: -140,
              right: -120,
              child: _AmbientGlow(
                size: 280,
                colors: [Color(0x441F6CFF), Color(0x002B59FF)],
              ),
            ),
            const Positioned(
              bottom: 180,
              left: -90,
              child: _AmbientGlow(
                size: 220,
                colors: [Color(0x33FFD447), Color(0x00FFD447)],
              ),
            ),
          ],
          navigationShell,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
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
              'Verify',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.94)
                    : ColorTokens.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusTokens.xl),
              gradient: GradientTokens.accentPill,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88FFCD3A),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: FloatingActionButton(
              key: const Key('homeShell_verifyFab'),
              tooltip: 'Open verification capture',
              onPressed: () => context.push(RouteNames.verifyCapturePath),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: const Color(0xFF111318),
              child: const Icon(Icons.videocam_rounded),
            ),
          ),
        ],
      ),
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
                    label: 'Home',
                    selected: navigationShell.currentIndex == 0,
                    onTap: () => goToBranch(0),
                  ),
                ),
                Expanded(
                  child: _BottomItem(
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: 'Search',
                    selected: navigationShell.currentIndex == 1,
                    onTap: () => goToBranch(1),
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: _BottomItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
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
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: selected
                    ? activeColor.withValues(alpha: 0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
              ),
              child: Icon(
                selected ? activeIcon : icon,
                color: selected ? activeColor : inactiveColor,
                size: 18,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected ? activeColor : inactiveColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends HookWidget {
  const _AmbientGlow({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
