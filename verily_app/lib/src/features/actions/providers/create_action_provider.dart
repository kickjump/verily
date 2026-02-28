import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// ignore: experimental_member_use
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'create_action_provider.g.dart';

/// Manages the lifecycle of creating a new action on the server.
@riverpod
class CreateAction extends _$CreateAction {
  @override
  AsyncValue<Action?> build() => const AsyncData(null);

  /// Submits a new action to the server.
  Future<Action?> submit({
    required String title,
    required String description,
    required String actionType,
    required String verificationCriteria,
    String? category,
    int? maxPerformers,
    String? locationName,
    double? locationLat,
    double? locationLng,
    double? locationRadius,
    String? stepOrdering,
    int? totalSteps,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    List<String>? tags,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);

      final action = Action(
        title: title,
        description: description,
        actionType: actionType,
        verificationCriteria: verificationCriteria,
        status: 'active',
        totalSteps: totalSteps ?? 1,
        // ignore: experimental_member_use
        creatorId: UuidValue.nil, // Server overrides from session
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await client.action.create(action);
      state = AsyncData(created);
      return created;
    } on Exception catch (e, st) {
      debugPrint('Failed to create action: $e');
      state = AsyncError(e, st);
      return null;
    }
  }

  /// Resets the creation state.
  void reset() {
    state = const AsyncData(null);
  }
}
