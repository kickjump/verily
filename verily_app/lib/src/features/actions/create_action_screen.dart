import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:verily_app/src/features/actions/providers/create_action_provider.dart';
import 'package:verily_app/src/features/search/search_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_core/verily_core.dart';
import 'package:verily_ui/verily_ui.dart';

/// Multi-step form for creating a new action.
class CreateActionScreen extends HookConsumerWidget {
  const CreateActionScreen({super.key});

  static const _totalSteps = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Current step (0-indexed)
    final currentStep = useState(0);
    final isSubmitting = useState(false);

    // Step 1: Basic info
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedActionType = useState(ActionType.oneOff);

    // Step 2: Verification
    final criteriaController = useTextEditingController();
    final selectedCategory = useState<String?>(null);

    // Step 3: Location and limits
    final locationNameController = useTextEditingController();
    final locationEnabled = useState(false);
    final locationLatLng = useState<LatLng?>(null);
    final locationRadius = useState<double>(200);
    final maxPerformersController = useTextEditingController();

    // Form keys per step
    final formKeys = useMemoized(
      () => List.generate(_totalSteps, (_) => GlobalKey<FormState>()),
    );

    void goToNextStep() {
      if (formKeys[currentStep.value].currentState?.validate() ?? false) {
        if (currentStep.value < _totalSteps - 1) {
          currentStep.value++;
        }
      }
    }

    void goToPreviousStep() {
      if (currentStep.value > 0) {
        currentStep.value--;
      } else {
        context.pop();
      }
    }

    Future<void> submitAction() async {
      isSubmitting.value = true;
      try {
        final result = await ref
            .read(createActionProvider.notifier)
            .submit(
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
              actionType: selectedActionType.value.value,
              verificationCriteria: criteriaController.text.trim(),
              category: selectedCategory.value,
              maxPerformers: maxPerformersController.text.isNotEmpty
                  ? int.tryParse(maxPerformersController.text)
                  : null,
              locationName: locationEnabled.value
                  ? locationNameController.text.trim()
                  : null,
              locationLat: locationEnabled.value
                  ? locationLatLng.value?.latitude
                  : null,
              locationLng: locationEnabled.value
                  ? locationLatLng.value?.longitude
                  : null,
              locationRadius: locationEnabled.value
                  ? locationRadius.value
                  : null,
            );
        if (context.mounted) {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action created successfully!')),
            );
            context.go(RouteNames.feedPath);
          } else {
            isSubmitting.value = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to create action. Please try again.'),
              ),
            );
          }
        }
      } on Exception {
        isSubmitting.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create action. Please try again.'),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goToPreviousStep,
        ),
        title: Text('Create Action (${currentStep.value + 1}/$_totalSteps)'),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentStep.value + 1) / _totalSteps,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),

          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: _buildStepContent(
                context: context,
                ref: ref,
                currentStep: currentStep.value,
                formKeys: formKeys,
                titleController: titleController,
                descriptionController: descriptionController,
                selectedActionType: selectedActionType,
                criteriaController: criteriaController,
                selectedCategory: selectedCategory,
                locationNameController: locationNameController,
                locationEnabled: locationEnabled,
                locationLatLng: locationLatLng,
                locationRadius: locationRadius,
                maxPerformersController: maxPerformersController,
                onJumpToStep: (step) => currentStep.value = step,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.md),
          child: Row(
            children: [
              if (currentStep.value > 0) ...[
                Expanded(
                  child: VOutlinedButton(
                    onPressed: goToPreviousStep,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: SpacingTokens.md),
              ],
              Expanded(
                flex: currentStep.value > 0 ? 2 : 1,
                child: currentStep.value == _totalSteps - 1
                    ? VFilledButton(
                        isLoading: isSubmitting.value,
                        onPressed: isSubmitting.value ? null : submitAction,
                        child: const Text('Create Action'),
                      )
                    : VFilledButton(
                        onPressed: goToNextStep,
                        child: const Text('Continue'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent({
    required BuildContext context,
    required WidgetRef ref,
    required int currentStep,
    required List<GlobalKey<FormState>> formKeys,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required ValueNotifier<ActionType> selectedActionType,
    required TextEditingController criteriaController,
    required ValueNotifier<String?> selectedCategory,
    required TextEditingController locationNameController,
    required ValueNotifier<bool> locationEnabled,
    required ValueNotifier<LatLng?> locationLatLng,
    required ValueNotifier<double> locationRadius,
    required TextEditingController maxPerformersController,
    required ValueChanged<int> onJumpToStep,
  }) {
    switch (currentStep) {
      case 0:
        return _StepBasicInfo(
          formKey: formKeys[0],
          titleController: titleController,
          descriptionController: descriptionController,
          selectedActionType: selectedActionType,
        );
      case 1:
        return _StepVerification(
          formKey: formKeys[1],
          ref: ref,
          criteriaController: criteriaController,
          selectedCategory: selectedCategory,
        );
      case 2:
        return _StepLocation(
          formKey: formKeys[2],
          locationNameController: locationNameController,
          locationEnabled: locationEnabled,
          locationLatLng: locationLatLng,
          locationRadius: locationRadius,
          maxPerformersController: maxPerformersController,
        );
      case 3:
        return _StepReview(
          formKey: formKeys[3],
          title: titleController.text,
          description: descriptionController.text,
          actionType: selectedActionType.value,
          criteria: criteriaController.text,
          category: selectedCategory.value,
          locationName: locationEnabled.value
              ? locationNameController.text
              : null,
          maxPerformers: maxPerformersController.text,
          onJumpToStep: onJumpToStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Step 1: Title, description, and action type.
class _StepBasicInfo extends HookWidget {
  const _StepBasicInfo({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedActionType,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ValueNotifier<ActionType> selectedActionType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Describe the action you want people to perform.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Title
          VTextField(
            controller: titleController,
            labelText: 'Title',
            hintText: 'e.g., Do 20 push-ups in the park',
            prefixIcon: const Icon(Icons.title),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required';
              }
              if (value.trim().length < 5) {
                return 'Title must be at least 5 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: SpacingTokens.md),

          // Description
          VTextField(
            controller: descriptionController,
            labelText: 'Description',
            hintText: 'Describe what the performer needs to do...',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              if (value.trim().length < 20) {
                return 'Description must be at least 20 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Action type
          Text(
            'Action Type',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          ...ActionType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: _ActionTypeCard(
                type: type,
                isSelected: selectedActionType.value == type,
                onTap: () => selectedActionType.value = type,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for selecting an action type.
class _ActionTypeCard extends HookWidget {
  const _ActionTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ActionType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.md),
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: Border.all(
            color: isSelected ? ColorTokens.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? ColorTokens.primary.withAlpha(10)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              type == ActionType.oneOff
                  ? Icons.bolt_outlined
                  : Icons.format_list_numbered,
              color: isSelected
                  ? ColorTokens.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? ColorTokens.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    type == ActionType.oneOff
                        ? 'A single action completed in one video'
                        : 'Multi-step action completed over time',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: ColorTokens.primary),
          ],
        ),
      ),
    );
  }
}

/// Step 2: Verification criteria and category.
class _StepVerification extends HookWidget {
  const _StepVerification({
    required this.formKey,
    required this.ref,
    required this.criteriaController,
    required this.selectedCategory,
  });

  final GlobalKey<FormState> formKey;
  final WidgetRef ref;
  final TextEditingController criteriaController;
  final ValueNotifier<String?> selectedCategory;

  /// Fallback categories used when the server is unreachable.
  static const _fallbackCategories = [
    'Fitness',
    'Environment',
    'Community',
    'Education',
    'Wellness',
    'Creative',
    'Adventure',
    'Charity',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(actionCategoriesProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Define how the AI should verify video submissions.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Verification criteria
          VTextField(
            controller: criteriaController,
            labelText: 'Verification Criteria',
            hintText:
                'Describe what the AI should look for in the video...\n'
                'e.g., Person must be visible doing push-ups, '
                'park visible in background',
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Verification criteria are required';
              }
              if (value.trim().length < 20) {
                return 'Please provide more detailed criteria (at least 20 characters)';
              }
              return null;
            },
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Category selection
          Text(
            'Category',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          categoriesAsync.when(
            loading: () => Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: _fallbackCategories
                  .map((c) => ChoiceChip(label: Text(c), selected: false))
                  .toList(),
            ),
            error: (_, __) => Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: _fallbackCategories.map((category) {
                final isSelected = selectedCategory.value == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedCategory.value = selected ? category : null;
                  },
                  selectedColor: ColorTokens.primary.withAlpha(30),
                );
              }).toList(),
            ),
            data: (categories) => Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: categories.map((category) {
                final isSelected = selectedCategory.value == category.name;
                return ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedCategory.value = selected ? category.name : null;
                  },
                  selectedColor: ColorTokens.primary.withAlpha(30),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 3: Location and performer limits.
class _StepLocation extends HookWidget {
  const _StepLocation({
    required this.formKey,
    required this.locationNameController,
    required this.locationEnabled,
    required this.locationLatLng,
    required this.locationRadius,
    required this.maxPerformersController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController locationNameController;
  final ValueNotifier<bool> locationEnabled;
  final ValueNotifier<LatLng?> locationLatLng;
  final ValueNotifier<double> locationRadius;
  final TextEditingController maxPerformersController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location & Limits',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Optionally restrict where this action can be performed.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Location toggle
          VCard(
            padding: const EdgeInsets.all(SpacingTokens.md),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, color: colorScheme.primary),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Require Location',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Performers must be at a specific location',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: locationEnabled.value,
                  onChanged: (value) => locationEnabled.value = value,
                ),
              ],
            ),
          ),

          if (locationEnabled.value) ...[
            const SizedBox(height: SpacingTokens.md),
            VTextField(
              controller: locationNameController,
              labelText: 'Location Name',
              hintText: 'e.g., Central Park',
              prefixIcon: const Icon(Icons.place_outlined),
            ),
            const SizedBox(height: SpacingTokens.md),
            LocationPickerMap(
              initialCenter: locationLatLng.value,
              initialRadius: locationRadius.value,
              onCenterChanged: (LatLng center) => locationLatLng.value = center,
              onConfirm: (LocationPickerResult result) {
                locationLatLng.value = LatLng(
                  result.point.latitude,
                  result.point.longitude,
                );
                locationRadius.value = result.radiusMeters;
              },
            ),
          ],
          const SizedBox(height: SpacingTokens.lg),

          // Max performers
          Text(
            'Maximum Performers',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          VTextField(
            controller: maxPerformersController,
            labelText: 'Max Performers (optional)',
            hintText: 'Leave empty for unlimited',
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.people_outline),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final number = int.tryParse(value);
                if (number == null || number < 1) {
                  return 'Enter a valid number greater than 0';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

/// Step 4: Review and submit.
class _StepReview extends HookWidget {
  const _StepReview({
    required this.formKey,
    required this.title,
    required this.description,
    required this.actionType,
    required this.criteria,
    required this.maxPerformers,
    required this.onJumpToStep,
    this.category,
    this.locationName,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String description;
  final ActionType actionType;
  final String criteria;
  final String? category;
  final String? locationName;
  final String maxPerformers;
  final ValueChanged<int> onJumpToStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Tap any section to edit it.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),

          _ReviewField(
            label: 'Title',
            value: title,
            onTap: () => onJumpToStep(0),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Description',
            value: description,
            onTap: () => onJumpToStep(0),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Type',
            value: actionType.displayName,
            onTap: () => onJumpToStep(0),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Verification Criteria',
            value: criteria,
            onTap: () => onJumpToStep(1),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Category',
            value: category ?? 'None selected',
            onTap: () => onJumpToStep(1),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Location',
            value: locationName ?? 'No location restriction',
            onTap: () => onJumpToStep(2),
          ),
          const SizedBox(height: SpacingTokens.md),
          _ReviewField(
            label: 'Max Performers',
            value: maxPerformers.isEmpty ? 'Unlimited' : maxPerformers,
            onTap: () => onJumpToStep(2),
          ),
        ],
      ),
    );
  }
}

/// A single review field showing a label and value.
///
/// When [onTap] is provided, the card shows an edit icon and is tappable
/// to jump back to the relevant form step.
class _ReviewField extends HookWidget {
  const _ReviewField({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.edit_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
