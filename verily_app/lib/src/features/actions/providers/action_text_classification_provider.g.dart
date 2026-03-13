// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_text_classification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a singleton [ActionTextClassifier] instance.
///
/// Pure Dart, zero-latency — can be read synchronously with `ref.read`.

@ProviderFor(actionTextClassifier)
final actionTextClassifierProvider = ActionTextClassifierProvider._();

/// Provides a singleton [ActionTextClassifier] instance.
///
/// Pure Dart, zero-latency — can be read synchronously with `ref.read`.

final class ActionTextClassifierProvider
    extends
        $FunctionalProvider<
          ActionTextClassifier,
          ActionTextClassifier,
          ActionTextClassifier
        >
    with $Provider<ActionTextClassifier> {
  /// Provides a singleton [ActionTextClassifier] instance.
  ///
  /// Pure Dart, zero-latency — can be read synchronously with `ref.read`.
  ActionTextClassifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionTextClassifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionTextClassifierHash();

  @$internal
  @override
  $ProviderElement<ActionTextClassifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActionTextClassifier create(Ref ref) {
    return actionTextClassifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionTextClassifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionTextClassifier>(value),
    );
  }
}

String _$actionTextClassifierHash() =>
    r'd051a464cce41df678d54264e700ed7e429f96ba';

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

@ProviderFor(actionTextClassification)
final actionTextClassificationProvider = ActionTextClassificationFamily._();

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

final class ActionTextClassificationProvider
    extends
        $FunctionalProvider<
          ActionTextClassification,
          ActionTextClassification,
          ActionTextClassification
        >
    with $Provider<ActionTextClassification> {
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
  ActionTextClassificationProvider._({
    required ActionTextClassificationFamily super.from,
    required ({String? title, String? description}) super.argument,
  }) : super(
         retry: null,
         name: r'actionTextClassificationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionTextClassificationHash();

  @override
  String toString() {
    return r'actionTextClassificationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ActionTextClassification> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActionTextClassification create(Ref ref) {
    final argument = this.argument as ({String? title, String? description});
    return actionTextClassification(
      ref,
      title: argument.title,
      description: argument.description,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionTextClassification value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionTextClassification>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActionTextClassificationProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionTextClassificationHash() =>
    r'a306e8cf1b2f7f97e9ea7988e1a56c12db559e42';

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

final class ActionTextClassificationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ActionTextClassification,
          ({String? title, String? description})
        > {
  ActionTextClassificationFamily._()
    : super(
        retry: null,
        name: r'actionTextClassificationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

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

  ActionTextClassificationProvider call({String? title, String? description}) =>
      ActionTextClassificationProvider._(
        argument: (title: title, description: description),
        from: this,
      );

  @override
  String toString() => r'actionTextClassificationProvider';
}
