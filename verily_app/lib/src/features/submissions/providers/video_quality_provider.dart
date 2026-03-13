import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/features/submissions/services/video_quality_analyzer.dart';

part 'video_quality_provider.g.dart';

/// Provides a singleton [VideoQualityAnalyzer] instance.
@riverpod
VideoQualityAnalyzer videoQualityAnalyzer(Ref ref) {
  final analyzer = VideoQualityAnalyzer();
  ref.onDispose(analyzer.dispose);
  return analyzer;
}

/// Runs on-device video quality analysis for the given [videoPath].
///
/// Returns a [VideoQualityReport] containing individual check results
/// and an overall pass/fail status.
@riverpod
Future<VideoQualityReport> videoQualityAnalysis(
  Ref ref,
  String videoPath,
) async {
  final analyzer = ref.watch(videoQualityAnalyzerProvider);
  try {
    return await analyzer.analyze(videoPath);
  } on Exception catch (e) {
    debugPrint('Video quality analysis failed: $e');
    // Return a permissive report — don't block submission on analysis failure.
    return const VideoQualityReport(
      checks: [],
      overallPassed: true,
      analysisTimeMs: 0,
    );
  }
}
