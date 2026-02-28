// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single submission by its database [id].

@ProviderFor(fetchSubmission)
final fetchSubmissionProvider = FetchSubmissionFamily._();

/// Fetches a single submission by its database [id].

final class FetchSubmissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActionSubmission>,
          ActionSubmission,
          FutureOr<ActionSubmission>
        >
    with $FutureModifier<ActionSubmission>, $FutureProvider<ActionSubmission> {
  /// Fetches a single submission by its database [id].
  FetchSubmissionProvider._({
    required FetchSubmissionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'fetchSubmissionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchSubmissionHash();

  @override
  String toString() {
    return r'fetchSubmissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ActionSubmission> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActionSubmission> create(Ref ref) {
    final argument = this.argument as int;
    return fetchSubmission(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchSubmissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchSubmissionHash() => r'f37b6757a9087bb7c8d5609a529953d332c707d1';

/// Fetches a single submission by its database [id].

final class FetchSubmissionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ActionSubmission>, int> {
  FetchSubmissionFamily._()
    : super(
        retry: null,
        name: r'fetchSubmissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single submission by its database [id].

  FetchSubmissionProvider call(int id) =>
      FetchSubmissionProvider._(argument: id, from: this);

  @override
  String toString() => r'fetchSubmissionProvider';
}

/// Fetches the verification result for a [submissionId].
///
/// Returns `null` while the verification is still in progress.

@ProviderFor(verificationResult)
final verificationResultProvider = VerificationResultFamily._();

/// Fetches the verification result for a [submissionId].
///
/// Returns `null` while the verification is still in progress.

final class VerificationResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerificationResult?>,
          VerificationResult?,
          FutureOr<VerificationResult?>
        >
    with
        $FutureModifier<VerificationResult?>,
        $FutureProvider<VerificationResult?> {
  /// Fetches the verification result for a [submissionId].
  ///
  /// Returns `null` while the verification is still in progress.
  VerificationResultProvider._({
    required VerificationResultFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'verificationResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verificationResultHash();

  @override
  String toString() {
    return r'verificationResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VerificationResult?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerificationResult?> create(Ref ref) {
    final argument = this.argument as int;
    return verificationResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VerificationResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verificationResultHash() =>
    r'450311b28e00992dff9774386f052b21572f3528';

/// Fetches the verification result for a [submissionId].
///
/// Returns `null` while the verification is still in progress.

final class VerificationResultFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VerificationResult?>, int> {
  VerificationResultFamily._()
    : super(
        retry: null,
        name: r'verificationResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the verification result for a [submissionId].
  ///
  /// Returns `null` while the verification is still in progress.

  VerificationResultProvider call(int submissionId) =>
      VerificationResultProvider._(argument: submissionId, from: this);

  @override
  String toString() => r'verificationResultProvider';
}

/// Polls the verification result for [submissionId] until it resolves.
///
/// The provider auto-refreshes every 3 seconds while the submission status
/// is still `pending` or `processing`.

@ProviderFor(verificationPoll)
final verificationPollProvider = VerificationPollFamily._();

/// Polls the verification result for [submissionId] until it resolves.
///
/// The provider auto-refreshes every 3 seconds while the submission status
/// is still `pending` or `processing`.

final class VerificationPollProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerificationResult?>,
          VerificationResult?,
          Stream<VerificationResult?>
        >
    with
        $FutureModifier<VerificationResult?>,
        $StreamProvider<VerificationResult?> {
  /// Polls the verification result for [submissionId] until it resolves.
  ///
  /// The provider auto-refreshes every 3 seconds while the submission status
  /// is still `pending` or `processing`.
  VerificationPollProvider._({
    required VerificationPollFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'verificationPollProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verificationPollHash();

  @override
  String toString() {
    return r'verificationPollProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<VerificationResult?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VerificationResult?> create(Ref ref) {
    final argument = this.argument as int;
    return verificationPoll(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VerificationPollProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verificationPollHash() => r'e8d2a11cbf6b52e5d5316019235ece95e68d2a2b';

/// Polls the verification result for [submissionId] until it resolves.
///
/// The provider auto-refreshes every 3 seconds while the submission status
/// is still `pending` or `processing`.

final class VerificationPollFamily extends $Family
    with $FunctionalFamilyOverride<Stream<VerificationResult?>, int> {
  VerificationPollFamily._()
    : super(
        retry: null,
        name: r'verificationPollProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Polls the verification result for [submissionId] until it resolves.
  ///
  /// The provider auto-refreshes every 3 seconds while the submission status
  /// is still `pending` or `processing`.

  VerificationPollProvider call(int submissionId) =>
      VerificationPollProvider._(argument: submissionId, from: this);

  @override
  String toString() => r'verificationPollProvider';
}

/// Manages the submission creation lifecycle.

@ProviderFor(SubmissionNotifier)
final submissionProvider = SubmissionNotifierProvider._();

/// Manages the submission creation lifecycle.
final class SubmissionNotifierProvider
    extends
        $NotifierProvider<SubmissionNotifier, AsyncValue<ActionSubmission?>> {
  /// Manages the submission creation lifecycle.
  SubmissionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionNotifierHash();

  @$internal
  @override
  SubmissionNotifier create() => SubmissionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ActionSubmission?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ActionSubmission?>>(
        value,
      ),
    );
  }
}

String _$submissionNotifierHash() =>
    r'e266db1a7fa1931217d837519affd01df690c230';

/// Manages the submission creation lifecycle.

abstract class _$SubmissionNotifier
    extends $Notifier<AsyncValue<ActionSubmission?>> {
  AsyncValue<ActionSubmission?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ActionSubmission?>,
              AsyncValue<ActionSubmission?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ActionSubmission?>,
                AsyncValue<ActionSubmission?>
              >,
              AsyncValue<ActionSubmission?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
