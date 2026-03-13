import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as api;
import 'package:verily_ui/verily_ui.dart';

/// A bottom sheet showing details for a selected action on the map.
///
/// Styled with rounded top corners and a drag handle, similar to the
/// reference design.
class ActionDetailBottomSheet extends HookWidget {
  const ActionDetailBottomSheet({
    required this.action,
    required this.onClose,
    super.key,
  });

  final api.Action action;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.lg),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: SpacingTokens.md),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(60),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header with close button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.xs),

              // Description
              Text(
                action.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: SpacingTokens.md),

              // Action type badge
              Row(
                children: [
                  VBadgeChip(
                    label: action.actionType,
                    backgroundColor: ColorTokens.primary.withAlpha(20),
                    foregroundColor: ColorTokens.primary,
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                  VBadgeChip(
                    label: action.status,
                    backgroundColor: ColorTokens.success.withAlpha(20),
                    foregroundColor: ColorTokens.success,
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.md),

              // View Details CTA
              SizedBox(
                width: double.infinity,
                child: VFilledButton(
                  onPressed: () {
                    onClose();
                    if (action.id != null) {
                      context.pushNamed(
                        RouteNames.actionDetail,
                        pathParameters: {'actionId': '${action.id}'},
                      );
                    }
                  },
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
