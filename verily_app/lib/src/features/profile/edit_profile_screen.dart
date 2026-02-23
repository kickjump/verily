import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for editing the current user's profile.
class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Pre-populate from real user profile provider.
    final usernameController = useTextEditingController(text: 'johndoe');
    final displayNameController = useTextEditingController(text: 'John Doe');
    final bioController = useTextEditingController(
      text: 'Fitness enthusiast and community builder. '
          'Love completing real-world challenges!',
    );
    final isSaving = useState(false);
    final hasChanges = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // Track changes
    useEffect(
      () {
        void listener() => hasChanges.value = true;
        usernameController.addListener(listener);
        displayNameController.addListener(listener);
        bioController.addListener(listener);
        return () {
          usernameController.removeListener(listener);
          displayNameController.removeListener(listener);
          bioController.removeListener(listener);
        };
      },
      [usernameController, displayNameController, bioController],
    );

    Future<void> saveProfile() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      isSaving.value = true;
      try {
        // TODO: Save profile to Serverpod.
        await Future<void>.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.pop();
        }
      } on Exception {
        isSaving.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save profile. Please try again.'),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: SpacingTokens.sm),
            child: VFilledButton(
              isLoading: isSaving.value,
              onPressed: (hasChanges.value && !isSaving.value)
                  ? saveProfile
                  : null,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: SpacingTokens.md),

              // Avatar picker
              Stack(
                children: [
                  const VAvatar(initials: 'JD', radius: 56),
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
                        onPressed: () {
                          // TODO: Open image picker for avatar.
                        },
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.sm),
              VTextButton(
                onPressed: () {
                  // TODO: Open image picker.
                },
                child: const Text('Change Photo'),
              ),
              const SizedBox(height: SpacingTokens.lg),

              // Username field
              VTextField(
                controller: usernameController,
                labelText: 'Username',
                hintText: 'Choose a unique username',
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
                labelText: 'Display Name',
                hintText: 'Your public name',
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
                labelText: 'Bio',
                hintText: 'Tell others about yourself...',
                maxLines: 4,
                enabled: !isSaving.value,
              ),
              const SizedBox(height: SpacingTokens.lg),

              // Character count hint for bio
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
