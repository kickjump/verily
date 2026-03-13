// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_quality_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a singleton [VideoQualityAnalyzer] instance.

@ProviderFor(videoQualityAnalyzer)
final videoQualityAnalyzerProvider = VideoQualityAnalyzerProvider._();

/// Provides a singleton [VideoQualityAnalyzer] instance.

final class VideoQualityAnalyzerProvider
    extends
        $FunctionalProvider<
          VideoQualityAnalyzer,
          VideoQualityAnalyzer,
          VideoQualityAnalyzer
        >
    with $Provider<VideoQualityAnalyzer> {
  /// Provides a singleton [VideoQualityAnalyzer] instance.
  VideoQualityAnalyzerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoQualityAnalyzerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoQualityAnalyzerHash();

  @$internal
  @override
  $ProviderElement<VideoQualityAnalyzer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VideoQualityAnalyzer create(Ref ref) {
    return videoQualityAnalyzer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoQualityAnalyzer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoQualityAnalyzer>(value),
    );
  }
}

String _$videoQualityAnalyzerHash() =>
    r'55af7cb24fbac1688fafed1245beee5b05492306';

/// Runs on-device video quality analysis for the given [videoPath].
///
/// Returns a [VideoQualityReport] containing individual check results
/// and an overall pass/fail status.

@ProviderFor(videoQualityAnalysis)
final videoQualityAnalysisProvider = VideoQualityAnalysisFamily._();

/// Runs on-device video quality analysis for the given [videoPath].
///
/// Returns a [VideoQualityReport] containing individual check results
/// and an overall pass/fail status.

final class VideoQualityAnalysisProvider
    extends
        $FunctionalProvider<
          AsyncValue<VideoQualityReport>,
          VideoQualityReport,
          FutureOr<VideoQualityReport>
        >
    with
        $FutureModifier<VideoQualityReport>,
        $FutureProvider<VideoQualityReport> {
  /// Runs on-device video quality analysis for the given [videoPath].
  ///
  /// Returns a [VideoQualityReport] containing individual check results
  /// and an overall pass/fail status.
  VideoQualityAnalysisProvider._({
    required VideoQualityAnalysisFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'videoQualityAnalysisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoQualityAnalysisHash();

  @override
  String toString() {
    return r'videoQualityAnalysisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VideoQualityReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VideoQualityReport> create(Ref ref) {
    final argument = this.argument as String;
    return videoQualityAnalysis(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoQualityAnalysisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoQualityAnalysisHash() =>
    r'35faf71ed65ddc186c5c1ec62c7cef1e0e8f89f0';

/// Runs on-device video quality analysis for the given [videoPath].
///
/// Returns a [VideoQualityReport] containing individual check results
/// and an overall pass/fail status.

final class VideoQualityAnalysisFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VideoQualityReport>, String> {
  VideoQualityAnalysisFamily._()
    : super(
        retry: null,
        name: r'videoQualityAnalysisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Runs on-device video quality analysis for the given [videoPath].
  ///
  /// Returns a [VideoQualityReport] containing individual check results
  /// and an overall pass/fail status.

  VideoQualityAnalysisProvider call(String videoPath) =>
      VideoQualityAnalysisProvider._(argument: videoPath, from: this);

  @override
  String toString() => r'videoQualityAnalysisProvider';
}
