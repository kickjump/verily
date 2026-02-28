import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/theme_mode_provider.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for adjusting app settings.
class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = useState(true);
    final locationSharingEnabled = useState(true);
    final profilePublic = useState(true);

    ref.listen(authProvider, (previous, next) {
      if (next is Unauthenticated) {
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Appearance section
          const _SectionTitle(title: 'Appearance'),
          _ThemeModeTile(
            currentMode: themeMode,
            onChanged: (mode) =>
                ref.read(themeModeProvider.notifier).setThemeMode(mode),
          ),
          const Divider(),

          // Notifications section
          const _SectionTitle(title: 'Notifications'),
          _SettingsToggleTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Get notified about submissions and verifications',
            value: notificationsEnabled.value,
            onChanged: (value) => notificationsEnabled.value = value,
          ),
          const Divider(),

          // Privacy section
          const _SectionTitle(title: 'Privacy'),
          _SettingsToggleTile(
            icon: Icons.location_on_outlined,
            title: 'Location Sharing',
            subtitle: 'Share GPS data with video submissions',
            value: locationSharingEnabled.value,
            onChanged: (value) => locationSharingEnabled.value = value,
          ),
          _SettingsToggleTile(
            icon: Icons.visibility_outlined,
            title: 'Public Profile',
            subtitle: 'Allow others to see your profile and actions',
            value: profilePublic.value,
            onChanged: (value) => profilePublic.value = value,
          ),
          const Divider(),

          // About section
          const _SectionTitle(title: 'About'),
          _SettingsNavTile(
            icon: Icons.info_outline,
            title: 'About Verily',
            subtitle: 'Version 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Verily',
                applicationVersion: '1.0.0+1',
                applicationIcon: const Icon(
                  Icons.verified_rounded,
                  size: 48,
                  color: ColorTokens.primary,
                ),
                children: [
                  const Text(
                    'Verily is an AI-powered platform for real-world '
                    'action verification. Complete challenges, submit '
                    'video proof, and earn rewards.',
                  ),
                ],
              );
            },
          ),
          _SettingsNavTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // TODO(ifiokjr): Navigate to Terms of Service.
            },
          ),
          _SettingsNavTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO(ifiokjr): Navigate to Privacy Policy.
            },
          ),
          _SettingsNavTile(
            icon: Icons.code,
            title: 'Open Source Licenses',
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Verily',
                applicationVersion: '1.0.0+1',
              );
            },
          ),
          const Divider(),

          // Danger zone
          const SizedBox(height: SpacingTokens.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
            child: VFilledButton(
              onPressed: () {
                _showLogoutConfirmation(context, ref);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: colorScheme.onPrimary),
                  const SizedBox(width: SpacingTokens.sm),
                  const Text('Log Out'),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.xxl),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

/// Section title within the settings list.
class _SectionTitle extends HookWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.md,
        SpacingTokens.lg,
        SpacingTokens.md,
        SpacingTokens.sm,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Theme mode selector tile with radio-like options.
class _ThemeModeTile extends HookWidget {
  const _ThemeModeTile({required this.currentMode, required this.onChanged});

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modes = [
      (ThemeMode.system, 'System', Icons.brightness_auto_outlined),
      (ThemeMode.light, 'Light', Icons.light_mode_outlined),
      (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: SpacingTokens.md),
              Text('Theme', style: theme.textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: SpacingTokens.sm),
          Row(
            children: modes.map((mode) {
              final (value, label, icon) = mode;
              final isSelected = currentMode == value;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.xs,
                  ),
                  child: InkWell(
                    onTap: () => onChanged(value),
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: SpacingTokens.sm,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                        border: Border.all(
                          color: isSelected
                              ? ColorTokens.primary
                              : colorScheme.outline,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? ColorTokens.primary.withAlpha(10)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? ColorTokens.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: SpacingTokens.xs),
                          Text(
                            label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? ColorTokens.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// A toggle setting tile with icon, title, subtitle, and switch.
class _SettingsToggleTile extends HookWidget {
  const _SettingsToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// A navigation setting tile with icon, title, optional subtitle, and arrow.
class _SettingsNavTile extends HookWidget {
  const _SettingsNavTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
