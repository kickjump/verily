import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_core/verily_core.dart';

part 'ai_action_provider.g.dart';

/// Generates a structured action from a natural language description using AI.
@riverpod
class AiActionGenerator extends _$AiActionGenerator {
  @override
  AsyncValue<AiGeneratedAction?> build() => const AsyncData(null);

  /// Sends a natural language description to the server and receives back
  /// a structured [AiGeneratedAction].
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final result = await client.aiAction.generate(
        description,
        latitude: latitude,
        longitude: longitude,
      );
      state = AsyncData(result);
    } on Exception catch (e, st) {
      debugPrint('AI action generation failed: $e');
      state = AsyncError(e, st);
    }
  }

  /// Resets the generated action state.
  void reset() {
    state = const AsyncData(null);
  }
}

/// Generates verification criteria for an existing action title/description.
@riverpod
Future<String?> generateCriteria(
  Ref ref, {
  required String title,
  required String description,
}) async {
  final client = ref.read(serverpodClientProvider);
  try {
    return await client.aiAction.generateCriteria(title, description);
  } on Exception catch (e) {
    debugPrint('AI criteria generation failed: $e');
    return null;
  }
}
