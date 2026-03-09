import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/profile/providers/user_profile_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen for editing the current user's profile.
class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editProfileTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editProfileTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: SpacingTokens.md),
              Text(
                AppLocalizations.of(context).profileLoadFailed,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: SpacingTokens.md),
              FilledButton(
                onPressed: () => ref.invalidate(currentUserProfileProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
      ),
      data: (profile) => _EditProfileBody(profile: profile),
    );
  }
}

class _EditProfileBody extends HookConsumerWidget {
  const _EditProfileBody({required this.profile});

  final vc.UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usernameController = useTextEditingController(text: profile.username);
    final displayNameController = useTextEditingController(
      text: profile.displayName,
    );
    final bioController = useTextEditingController(text: profile.bio ?? '');
    final isSaving = useState(false);
    final hasChanges = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    useEffect(() {
      void listener() => hasChanges.value = true;
      usernameController.addListener(listener);
      displayNameController.addListener(listener);
      bioController.addListener(listener);
      return () {
        usernameController.removeListener(listener);
        displayNameController.removeListener(listener);
        bioController.removeListener(listener);
      };
    }, [usernameController, displayNameController, bioController]);

    Future<void> saveProfile() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      isSaving.value = true;
      try {
        final client = ref.read(serverpodClientProvider);
        final updated = profile.copyWith(
          username: usernameController.text.trim(),
          displayName: displayNameController.text.trim(),
          bio: bioController.text.trim().isEmpty
              ? null
              : bioController.text.trim(),
          updatedAt: DateTime.now().toUtc(),
        );
        await client.userProfile.update(updated);
        ref.invalidate(currentUserProfileProvider);
        if (context.mounted) {
          context.pop();
        }
      } on Exception {
        isSaving.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).profileFailedToSaveTryAgain,
              ),
            ),
          );
        }
      }
    }

    final initials = profile.displayName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editProfileTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: SpacingTokens.sm),
            child: VFilledButton(
              isLoading: isSaving.value,
              onPressed: (hasChanges.value && !isSaving.value)
                  ? saveProfile
                  : null,
              child: Text(AppLocalizations.of(context).save),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: SpacingTokens.md),

              // Avatar
              Stack(
                children: [
                  VAvatar(initials: initials, radius: 56),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primaryContainer,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 3,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () {},
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.lg),

              // Username field
              VTextField(
                controller: usernameController,
                labelText: AppLocalizations.of(context).profileUsername,
                hintText: AppLocalizations.of(
                  context,
                ).profileChooseUniqueUsername,
                prefixText: '@',
                prefixIcon: const Icon(Icons.alternate_email),
                enabled: !isSaving.value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                    return 'Only letters, numbers, and underscores';
                  }
                  return null;
                },
              ),
              const SizedBox(height: SpacingTokens.md),

              // Display name field
              VTextField(
                controller: displayNameController,
                labelText: AppLocalizations.of(context).displayName,
                hintText: AppLocalizations.of(context).profileYourPublicName,
                prefixIcon: const Icon(Icons.person_outline),
                enabled: !isSaving.value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Display name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: SpacingTokens.md),

              // Bio field
              VTextField(
                controller: bioController,
                labelText: AppLocalizations.of(context).profileBio,
                hintText: AppLocalizations.of(
                  context,
                ).profileTellOthersAboutYourself,
                maxLines: 4,
                enabled: !isSaving.value,
              ),
              const SizedBox(height: SpacingTokens.lg),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${bioController.text.length} / 250',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: bioController.text.length > 250
                        ? ColorTokens.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
