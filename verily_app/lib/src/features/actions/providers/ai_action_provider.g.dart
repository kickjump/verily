// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Generates a structured action from a natural language description using AI.

@ProviderFor(AiActionGenerator)
final aiActionGeneratorProvider = AiActionGeneratorProvider._();

/// Generates a structured action from a natural language description using AI.
final class AiActionGeneratorProvider
    extends
        $NotifierProvider<AiActionGenerator, AsyncValue<AiGeneratedAction?>> {
  /// Generates a structured action from a natural language description using AI.
  AiActionGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiActionGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiActionGeneratorHash();

  @$internal
  @override
  AiActionGenerator create() => AiActionGenerator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AiGeneratedAction?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AiGeneratedAction?>>(
        value,
      ),
    );
  }
}

String _$aiActionGeneratorHash() => r'f1ce9c8862103245d56191938ce8fed29a51bcdb';

/// Generates a structured action from a natural language description using AI.

abstract class _$AiActionGenerator
    extends $Notifier<AsyncValue<AiGeneratedAction?>> {
  AsyncValue<AiGeneratedAction?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AiGeneratedAction?>,
              AsyncValue<AiGeneratedAction?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AiGeneratedAction?>,
                AsyncValue<AiGeneratedAction?>
              >,
              AsyncValue<AiGeneratedAction?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Generates verification criteria for an existing action title/description.

@ProviderFor(generateCriteria)
final generateCriteriaProvider = GenerateCriteriaFamily._();

/// Generates verification criteria for an existing action title/description.

final class GenerateCriteriaProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Generates verification criteria for an existing action title/description.
  GenerateCriteriaProvider._({
    required GenerateCriteriaFamily super.from,
    required ({String title, String description}) super.argument,
  }) : super(
         retry: null,
         name: r'generateCriteriaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$generateCriteriaHash();

  @override
  String toString() {
    return r'generateCriteriaProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as ({String title, String description});
    return generateCriteria(
      ref,
      title: argument.title,
      description: argument.description,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateCriteriaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generateCriteriaHash() => r'fb10d17a944de08ed56435b351369c9313783baa';

/// Generates verification criteria for an existing action title/description.

final class GenerateCriteriaFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String?>,
          ({String title, String description})
        > {
  GenerateCriteriaFamily._()
    : super(
        retry: null,
        name: r'generateCriteriaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Generates verification criteria for an existing action title/description.

  GenerateCriteriaProvider call({
    required String title,
    required String description,
  }) => GenerateCriteriaProvider._(
    argument: (title: title, description: description),
    from: this,
  );

  @override
  String toString() => r'generateCriteriaProvider';
}
