import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_core/verily_core.dart';

part 'action_text_classification_provider.g.dart';

/// Provides a singleton [ActionTextClassifier] instance.
///
/// Pure Dart, zero-latency — can be read synchronously with `ref.read`.
@Riverpod(keepAlive: true)
ActionTextClassifier actionTextClassifier(Ref ref) {
  return const ActionTextClassifier();
}

/// Classifies action text reactively based on title and description.
///
/// This provider is designed to be watched from the action creation form.
/// It re-evaluates whenever title or description change, providing instant
/// category and type suggestions with no network round-trip.
///
/// Usage in a widget:
/// ```dart
/// // In a ConsumerWidget or HookConsumerWidget:
/// final classification = ref.watch(
///   actionTextClassificationProvider(
///     title: titleController.text,
///     description: descriptionController.text,
///   ),
/// );
///
/// if (classification.hasConfidentCategory) {
///   // Show: "Suggested category: ${classification.suggestedCategory!.displayName}"
/// }
/// if (classification.hasConfidentType) {
///   // Pre-select the action type dropdown
/// }
/// ```
@riverpod
ActionTextClassification actionTextClassification(
  Ref ref, {
  String? title,
  String? description,
}) {
  final classifier = ref.watch(actionTextClassifierProvider);
  return classifier.classify(title: title, description: description);
}
