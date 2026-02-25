import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:verily_app/src/routing/route_names.dart';

/// Root shell with bottom tabs and center verification action.
class HomeShellScaffold extends HookWidget {
  const HomeShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void goToBranch(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FCFF), Color(0xFFF1F7F5)],
          ),
        ),
        child: navigationShell,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.verifyCapturePath),
        backgroundColor: const Color(0xFF2F8F83),
        foregroundColor: Colors.white,
        child: const Icon(Icons.verified_outlined),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 12,
        color: theme.colorScheme.surface,
        child: SizedBox(
          height: 70,
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
                  label: 'Explore',
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? activeIcon : icon,
            color: selected
                ? const Color(0xFF2F8F83)
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected
                  ? const Color(0xFF2F8F83)
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
