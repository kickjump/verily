// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posthog_analytics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [Posthog] singleton for analytics operations.
///
/// Returns `null` when PostHog is not configured.

@ProviderFor(posthogInstance)
final posthogInstanceProvider = PosthogInstanceProvider._();

/// Provides the [Posthog] singleton for analytics operations.
///
/// Returns `null` when PostHog is not configured.

final class PosthogInstanceProvider
    extends $FunctionalProvider<Posthog?, Posthog?, Posthog?>
    with $Provider<Posthog?> {
  /// Provides the [Posthog] singleton for analytics operations.
  ///
  /// Returns `null` when PostHog is not configured.
  PosthogInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posthogInstanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posthogInstanceHash();

  @$internal
  @override
  $ProviderElement<Posthog?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Posthog? create(Ref ref) {
    return posthogInstance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Posthog? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Posthog?>(value),
    );
  }
}

String _$posthogInstanceHash() => r'7bd750361f4acdb068fb8d4878d3391224fd303f';
