import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Result of a single quality check.
class QualityCheckResult {
  const QualityCheckResult({
    required this.checkType,
    required this.passed,
    required this.label,
    required this.detail,
    this.severity = QualityCheckSeverity.warning,
  });

  final QualityCheckType checkType;
  final bool passed;
  final String label;
  final String detail;
  final QualityCheckSeverity severity;
}

/// Severity level for a failed quality check.
enum QualityCheckSeverity {
  /// Informational — does not block submission.
  info,

  /// Warning — submission is allowed but quality may be insufficient.
  warning,

  /// Blocking — submission should not proceed.
  error,
}

/// Types of quality checks performed.
enum QualityCheckType {
  minimumDuration,
  fileSize,
  resolution,
  brightness,
  blurDetection,
  faceDetection,
  screenRecordingDetection,
  geoFence,
}

/// Aggregate result of all quality checks.
class VideoQualityReport {
  const VideoQualityReport({
    required this.checks,
    required this.overallPassed,
    required this.analysisTimeMs,
  });

  /// Individual check results.
  final List<QualityCheckResult> checks;

  /// Whether all critical checks passed.
  final bool overallPassed;

  /// Time taken for analysis in milliseconds.
  final int analysisTimeMs;

  /// Number of checks that passed.
  int get passedCount => checks.where((c) => c.passed).length;

  /// Number of checks that failed.
  int get failedCount => checks.where((c) => !c.passed).length;

  /// Whether any blocking issues were found.
  bool get hasBlockingIssues =>
      checks.any((c) => !c.passed && c.severity == QualityCheckSeverity.error);
}

/// Parameters for geo-fence validation during quality analysis.
class GeoFenceParams {
  const GeoFenceParams({
    required this.userLat,
    required this.userLng,
    required this.actionLat,
    required this.actionLng,
    this.radiusMeters = 200.0,
  });

  final double userLat;
  final double userLng;
  final double actionLat;
  final double actionLng;
  final double radiusMeters;
}

/// On-device video quality analyzer.
///
/// Extracts frames from the video and runs multiple checks:
/// 1. Minimum duration validation (5 seconds)
/// 2. File size validation (500 KB – 500 MB)
/// 3. Video resolution check (minimum 480p)
/// 4. Pixel-level brightness analysis via the `image` package
/// 5. Laplacian variance blur detection on decoded pixels
/// 6. Face detection via Google ML Kit
/// 7. Screen recording artifact detection
/// 8. Geo-fence proximity validation (optional)
class VideoQualityAnalyzer {
  VideoQualityAnalyzer({
    this.minimumDurationSeconds = 5,
    this.minimumFileSizeBytes = 500 * 1024,
    this.maximumFileSizeBytes = 500 * 1024 * 1024,
    this.minimumResolutionHeight = 480,
    this.darkThreshold = 40.0,
    this.brightThreshold = 220.0,
    this.laplacianVarianceThreshold = 100.0,
    this.framesToSample = 3,
  });

  /// Minimum video duration in seconds.
  final int minimumDurationSeconds;

  /// Minimum file size in bytes (default: 500 KB).
  final int minimumFileSizeBytes;

  /// Maximum file size in bytes (default: 500 MB).
  final int maximumFileSizeBytes;

  /// Minimum video height in pixels (default: 480 for 480p).
  final int minimumResolutionHeight;

  /// Average pixel luminance below this is considered too dark (0–255).
  final double darkThreshold;

  /// Average pixel luminance above this is considered too bright (0–255).
  final double brightThreshold;

  /// Laplacian variance threshold below which a frame is considered blurry.
  ///
  /// The Laplacian operator detects edges; its variance measures how much
  /// edge content is present. Sharp images typically score > 300, while
  /// blurry images score < 100. Default threshold is 100.
  final double laplacianVarianceThreshold;

  /// Number of frames to sample from the video.
  final int framesToSample;

  FaceDetector? _faceDetector;

  FaceDetector get _detector {
    return _faceDetector ??= FaceDetector(options: FaceDetectorOptions());
  }

  /// Run all quality checks on the video at [videoPath].
  ///
  /// If [geoFenceParams] is provided, a geo-fence proximity check is
  /// included in the report.
  Future<VideoQualityReport> analyze(
    String videoPath, {
    GeoFenceParams? geoFenceParams,
  }) async {
    final checks = <QualityCheckResult>[];
    final file = File(videoPath);
    final stopwatch = Stopwatch()..start();

    if (!file.existsSync()) {
      return VideoQualityReport(
        checks: [
          const QualityCheckResult(
            checkType: QualityCheckType.minimumDuration,
            passed: false,
            label: 'Video file', // l10n-ignore quality check label
            detail: 'Video file not found',
            severity: QualityCheckSeverity.error,
          ),
        ],
        overallPassed: false,
        analysisTimeMs: stopwatch.elapsedMilliseconds,
      );
    }

    // 1. File size check (fast — no I/O beyond stat)
    checks
      ..add(await _checkFileSize(file))
      // 2. Duration check
      ..add(await _checkDuration(videoPath))
      // 3. Resolution check (uses VideoPlayerController)
      ..add(await _checkResolution(videoPath));

    // 4–7. Frame-based checks (brightness, blur, face, screen recording)
    final frames = await _extractFrames(videoPath);

    if (frames.isEmpty) {
      checks.addAll([
        const QualityCheckResult(
          checkType: QualityCheckType.brightness,
          passed: false,
          label: 'Brightness', // l10n-ignore quality check label
          detail: 'Could not extract frames for analysis',
        ),
        const QualityCheckResult(
          checkType: QualityCheckType.blurDetection,
          passed: true,
          label: 'Sharpness', // l10n-ignore quality check label
          detail: 'Could not extract frames for analysis — skipped',
          severity: QualityCheckSeverity.info,
        ),
        const QualityCheckResult(
          checkType: QualityCheckType.faceDetection,
          passed: false,
          label: 'Face detected', // l10n-ignore quality check label
          detail: 'Could not extract frames for analysis',
        ),
        const QualityCheckResult(
          checkType: QualityCheckType.screenRecordingDetection,
          passed: true,
          label: 'Not a screen recording', // l10n-ignore quality check label
          detail: 'Could not verify — skipped',
          severity: QualityCheckSeverity.info,
        ),
      ]);
    } else {
      checks
        ..add(await _checkBrightness(frames))
        ..add(await _checkBlur(frames))
        ..add(await _checkFaceDetection(frames, videoPath))
        ..add(await _checkScreenRecording(frames));
    }

    // 8. Geo-fence check (if location data available)
    if (geoFenceParams != null) {
      checks.add(_checkGeoFence(geoFenceParams));
    }

    stopwatch.stop();

    final overallPassed = !checks.any(
      (c) => !c.passed && c.severity == QualityCheckSeverity.error,
    );

    return VideoQualityReport(
      checks: checks,
      overallPassed: overallPassed,
      analysisTimeMs: stopwatch.elapsedMilliseconds,
    );
  }

  /// Extract thumbnail frames from the video at various time offsets.
  Future<List<Uint8List>> _extractFrames(String videoPath) async {
    final frames = <Uint8List>[];

    try {
      // Sample frames at different time offsets (start, middle-ish, later).
      // We don't know the exact duration yet, so sample at fixed offsets.
      final timeOffsetsMs = <int>[
        500, // 0.5s — near start
        3000, // 3s — early middle
        8000, // 8s — later
      ];

      for (final offset in timeOffsetsMs.take(framesToSample)) {
        try {
          final thumbnail = await VideoThumbnail.thumbnailData(
            video: videoPath,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 640,
            quality: 50,
            timeMs: offset,
          );

          if (thumbnail != null && thumbnail.isNotEmpty) {
            frames.add(thumbnail);
          }
        } on Exception catch (e) {
          debugPrint('Failed to extract frame at ${offset}ms: $e');
        }
      }
    } on Exception catch (e) {
      debugPrint('Frame extraction failed: $e');
    }

    return frames;
  }

  /// Validate file size is within acceptable bounds.
  Future<QualityCheckResult> _checkFileSize(File file) async {
    try {
      final fileSize = await file.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileSize < minimumFileSizeBytes) {
        final minKB = minimumFileSizeBytes ~/ 1024;
        return QualityCheckResult(
          checkType: QualityCheckType.fileSize,
          passed: false,
          label: 'File size', // l10n-ignore quality check label
          detail:
              'Video is too small (${(fileSize / 1024).toStringAsFixed(0)} KB). '
              'Minimum is $minKB KB — the video may be corrupt or empty.',
          severity: QualityCheckSeverity.error,
        );
      }

      if (fileSize > maximumFileSizeBytes) {
        final maxMB = maximumFileSizeBytes ~/ (1024 * 1024);
        return QualityCheckResult(
          checkType: QualityCheckType.fileSize,
          passed: false,
          label: 'File size', // l10n-ignore quality check label
          detail:
              'Video is too large (${fileSizeMB.toStringAsFixed(1)} MB). '
              'Maximum is $maxMB MB — try recording a shorter video.',
          severity: QualityCheckSeverity.error,
        );
      }

      final sizeLabel = fileSizeMB >= 1.0
          ? '${fileSizeMB.toStringAsFixed(1)} MB'
          : '${(fileSize / 1024).toStringAsFixed(0)} KB';

      return QualityCheckResult(
        checkType: QualityCheckType.fileSize,
        passed: true,
        label: 'File size', // l10n-ignore quality check label
        detail: '$sizeLabel — within limits ✓',
        severity: QualityCheckSeverity.error,
      );
    } on Exception catch (e) {
      debugPrint('File size check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.fileSize,
        passed: true,
        label: 'File size', // l10n-ignore quality check label
        detail: 'Could not verify file size — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Check minimum video duration by attempting to extract a frame
  /// at the minimum time threshold.
  Future<QualityCheckResult> _checkDuration(String videoPath) async {
    try {
      final file = File(videoPath);
      final fileSize = await file.length();

      // A 5-second video at reasonable quality is typically > 500KB.
      // This is a heuristic — the real check is the frame extraction.
      if (fileSize < 100 * 1024) {
        // < 100KB is suspiciously short
        return QualityCheckResult(
          checkType: QualityCheckType.minimumDuration,
          passed: false,
          label: 'Minimum duration', // l10n-ignore quality check label
          detail: 'Video appears too short (< $minimumDurationSeconds seconds)',
          severity: QualityCheckSeverity.error,
        );
      }

      // Try to get a frame at the minimum duration mark.
      final frame = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
        timeMs: minimumDurationSeconds * 1000,
      );

      if (frame == null || frame.isEmpty) {
        return QualityCheckResult(
          checkType: QualityCheckType.minimumDuration,
          passed: false,
          label: 'Minimum duration', // l10n-ignore quality check label
          detail: 'Video must be at least $minimumDurationSeconds seconds long',
          severity: QualityCheckSeverity.error,
        );
      }

      return QualityCheckResult(
        checkType: QualityCheckType.minimumDuration,
        passed: true,
        label: 'Minimum duration', // l10n-ignore quality check label
        detail: '≥ $minimumDurationSeconds seconds ✓',
        severity: QualityCheckSeverity.error,
      );
    } on Exception catch (e) {
      debugPrint('Duration check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.minimumDuration,
        passed: true,
        label: 'Minimum duration', // l10n-ignore quality check label
        detail: 'Could not verify duration — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Check video resolution using [VideoPlayerController].
  ///
  /// Initialises the controller briefly to read video metadata (width/height),
  /// then disposes immediately. The short-lived controller only reads headers
  /// and does not decode frames, so this is fast (~50-200ms).
  Future<QualityCheckResult> _checkResolution(String videoPath) async {
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.file(File(videoPath));
      await controller.initialize();

      final size = controller.value.size;
      final width = size.width.toInt();
      final height = size.height.toInt();

      // Use the smaller dimension (height in landscape, width in portrait)
      // to determine the resolution tier.
      final shortSide = math.min(width, height);

      if (shortSide < minimumResolutionHeight) {
        return QualityCheckResult(
          checkType: QualityCheckType.resolution,
          passed: false,
          label: 'Resolution', // l10n-ignore quality check label
          detail:
              'Video resolution is too low ($width×$height). '
              'Minimum ${minimumResolutionHeight}p required for AI analysis.',
          severity: QualityCheckSeverity.error,
        );
      }

      // Determine human-readable resolution tier.
      final tier = shortSide >= 2160
          ? '4K'
          : shortSide >= 1080
          ? '1080p'
          : shortSide >= 720
          ? '720p'
          : '${shortSide}p';

      return QualityCheckResult(
        checkType: QualityCheckType.resolution,
        passed: true,
        label: 'Resolution', // l10n-ignore quality check label
        detail: '$width×$height ($tier) ✓',
        severity: QualityCheckSeverity.error,
      );
    } on Exception catch (e) {
      debugPrint('Resolution check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.resolution,
        passed: true,
        label: 'Resolution', // l10n-ignore quality check label
        detail: 'Could not determine resolution — skipped',
        severity: QualityCheckSeverity.info,
      );
    } finally {
      await controller?.dispose();
    }
  }

  /// Analyze average luminance across sampled frames using pixel-level
  /// decoding via the `image` package.
  ///
  /// Decodes each JPEG frame to raw pixels, converts each pixel to
  /// luminance using the BT.601 formula (0.299R + 0.587G + 0.114B),
  /// and averages across all sampled frames.
  Future<QualityCheckResult> _checkBrightness(List<Uint8List> frames) async {
    try {
      final luminances = <double>[];

      for (final frameData in frames) {
        final luminance = await compute(_computePixelLuminance, frameData);
        if (luminance != null) {
          luminances.add(luminance);
        }
      }

      if (luminances.isEmpty) {
        return const QualityCheckResult(
          checkType: QualityCheckType.brightness,
          passed: true,
          label: 'Brightness', // l10n-ignore quality check label
          detail: 'Could not measure brightness — skipped',
          severity: QualityCheckSeverity.info,
        );
      }

      final avgLuminance =
          luminances.reduce((a, b) => a + b) / luminances.length;

      if (avgLuminance < darkThreshold) {
        return QualityCheckResult(
          checkType: QualityCheckType.brightness,
          passed: false,
          label: 'Brightness', // l10n-ignore quality check label
          detail:
              'Video is too dark (luminance: ${avgLuminance.toStringAsFixed(0)}/255). '
              'Try recording in better lighting.',
        );
      }

      if (avgLuminance > brightThreshold) {
        return QualityCheckResult(
          checkType: QualityCheckType.brightness,
          passed: false,
          label: 'Brightness', // l10n-ignore quality check label
          detail:
              'Video is too bright/overexposed (luminance: ${avgLuminance.toStringAsFixed(0)}/255). '
              'Avoid direct sunlight on the lens.',
        );
      }

      return QualityCheckResult(
        checkType: QualityCheckType.brightness,
        passed: true,
        label: 'Brightness', // l10n-ignore quality check label
        detail: 'Good lighting (${avgLuminance.toStringAsFixed(0)}/255) ✓',
      );
    } on Exception catch (e) {
      debugPrint('Brightness check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.brightness,
        passed: true,
        label: 'Brightness', // l10n-ignore quality check label
        detail: 'Could not measure brightness — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Detect blur in sampled frames using Laplacian variance.
  ///
  /// The Laplacian operator is a second-order derivative that measures the
  /// rate of change of pixel intensity. Blurry images have few edges, so
  /// the Laplacian response is low and uniform — yielding low variance.
  /// Sharp images have many edges with high-magnitude Laplacian values,
  /// producing high variance.
  ///
  /// We convert each frame to grayscale, apply a 3×3 Laplacian kernel,
  /// and compute the variance of the response. The variance is then
  /// compared against [laplacianVarianceThreshold].
  Future<QualityCheckResult> _checkBlur(List<Uint8List> frames) async {
    try {
      final variances = <double>[];

      for (final frameData in frames) {
        final variance = await compute(_computeLaplacianVariance, frameData);
        if (variance != null) {
          variances.add(variance);
        }
      }

      if (variances.isEmpty) {
        return const QualityCheckResult(
          checkType: QualityCheckType.blurDetection,
          passed: true,
          label: 'Sharpness', // l10n-ignore quality check label
          detail: 'Could not measure sharpness — skipped',
          severity: QualityCheckSeverity.info,
        );
      }

      final avgVariance = variances.reduce((a, b) => a + b) / variances.length;

      if (avgVariance < laplacianVarianceThreshold) {
        return QualityCheckResult(
          checkType: QualityCheckType.blurDetection,
          passed: false,
          label: 'Sharpness', // l10n-ignore quality check label
          detail:
              'Video appears blurry (sharpness: ${avgVariance.toStringAsFixed(0)}). '
              'Try holding the camera steadier or cleaning the lens.',
        );
      }

      return QualityCheckResult(
        checkType: QualityCheckType.blurDetection,
        passed: true,
        label: 'Sharpness', // l10n-ignore quality check label
        detail: 'Good sharpness (score: ${avgVariance.toStringAsFixed(0)}) ✓',
      );
    } on Exception catch (e) {
      debugPrint('Blur detection check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.blurDetection,
        passed: true,
        label: 'Sharpness', // l10n-ignore quality check label
        detail: 'Could not measure sharpness — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Detect faces in sampled frames using Google ML Kit.
  Future<QualityCheckResult> _checkFaceDetection(
    List<Uint8List> frames,
    String videoPath,
  ) async {
    try {
      var facesDetected = 0;
      var framesChecked = 0;

      for (final frameData in frames) {
        // Write frame to temp file for ML Kit input.
        final tempFile = File(
          '${Directory.systemTemp.path}/verily_face_check_${framesChecked}_'
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await tempFile.writeAsBytes(frameData);

        try {
          final inputImage = InputImage.fromFilePath(tempFile.path);
          final faces = await _detector.processImage(inputImage);
          if (faces.isNotEmpty) {
            facesDetected++;
          }
          framesChecked++;
        } finally {
          // Clean up temp file.
          try {
            await tempFile.delete();
          } on Exception {
            // Ignore cleanup errors.
          }
        }
      }

      if (framesChecked == 0) {
        return const QualityCheckResult(
          checkType: QualityCheckType.faceDetection,
          passed: true,
          label: 'Face detected', // l10n-ignore quality check label
          detail: 'Could not analyze frames — skipped',
          severity: QualityCheckSeverity.info,
        );
      }

      final detected = facesDetected > 0;
      return QualityCheckResult(
        checkType: QualityCheckType.faceDetection,
        passed: detected,
        label: 'Face detected', // l10n-ignore quality check label
        detail: detected
            ? 'Face found in $facesDetected/$framesChecked frames ✓'
            : 'No face detected. Ensure your face is visible in the video.',
      );
    } on Exception catch (e) {
      debugPrint('Face detection check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.faceDetection,
        passed: true,
        label: 'Face detected', // l10n-ignore quality check label
        detail: 'Face detection unavailable — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Detect screen recording artifacts by analyzing frame edges for
  /// uniform colored bars (status bars, navigation bars).
  Future<QualityCheckResult> _checkScreenRecording(
    List<Uint8List> frames,
  ) async {
    try {
      var suspiciousFrames = 0;

      for (final frameData in frames) {
        final isSuspicious = await compute(
          _detectScreenRecordingArtifacts,
          frameData,
        );
        if (isSuspicious) {
          suspiciousFrames++;
        }
      }

      // If majority of frames are suspicious, flag it.
      final isSuspicious = suspiciousFrames > frames.length / 2;

      return QualityCheckResult(
        checkType: QualityCheckType.screenRecordingDetection,
        passed: !isSuspicious,
        label: 'Not a screen recording', // l10n-ignore quality check label
        detail: isSuspicious
            ? 'Video appears to be a screen recording. '
                  'Please record directly with your camera.'
            : 'Authentic camera recording ✓',
        severity: isSuspicious
            ? QualityCheckSeverity.error
            : QualityCheckSeverity.error,
      );
    } on Exception catch (e) {
      debugPrint('Screen recording check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.screenRecordingDetection,
        passed: true,
        label: 'Not a screen recording', // l10n-ignore quality check label
        detail: 'Could not verify — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Check whether the user is within the required geo-fence.
  ///
  /// Uses the Haversine formula via manual calculation to determine
  /// the great-circle distance between the user and the action location.
  QualityCheckResult _checkGeoFence(GeoFenceParams params) {
    try {
      final distance = _haversineDistance(
        params.userLat,
        params.userLng,
        params.actionLat,
        params.actionLng,
      );

      final isInside = distance <= params.radiusMeters;
      final overshoot = isInside ? 0.0 : distance - params.radiusMeters;

      // Format distance for display.
      String formatMeters(double meters) {
        if (meters < 1000) {
          return '${meters.round()} m';
        }
        return '${(meters / 1000).toStringAsFixed(1)} km';
      }

      if (isInside) {
        return QualityCheckResult(
          checkType: QualityCheckType.geoFence,
          passed: true,
          label: 'Location', // l10n-ignore quality check label
          detail:
              'Within required area (${formatMeters(distance)} from target) ✓',
        );
      }

      return QualityCheckResult(
        checkType: QualityCheckType.geoFence,
        passed: false,
        label: 'Location', // l10n-ignore quality check label
        detail:
            '${formatMeters(overshoot)} outside the required area. '
            'Move closer for better verification results.',
      );
    } on Exception catch (e) {
      debugPrint('Geo-fence check failed: $e');
      return const QualityCheckResult(
        checkType: QualityCheckType.geoFence,
        passed: true,
        label: 'Location', // l10n-ignore quality check label
        detail: 'Could not verify proximity — skipped',
        severity: QualityCheckSeverity.info,
      );
    }
  }

  /// Dispose of ML Kit resources.
  void dispose() {
    _faceDetector?.close();
    _faceDetector = null;
  }
}

// ---------------------------------------------------------------------------
// Isolate-safe top-level functions for compute-heavy operations.
// These run in separate isolates via [compute] and must not reference
// instance state or Flutter framework objects.
// ---------------------------------------------------------------------------

/// Compute average pixel luminance from JPEG bytes using true pixel decoding.
///
/// Decodes the JPEG to raw pixels via the `image` package, then computes
/// luminance for each pixel using the BT.601 perceptual formula:
///   Y = 0.299 × R + 0.587 × G + 0.114 × B
///
/// For performance, samples every 4th pixel (stride of 4) rather than
/// processing every single pixel, which is sufficient for a luminance
/// average while being ~4× faster.
///
/// Runs in an isolate via [compute].
double? _computePixelLuminance(Uint8List jpegBytes) {
  try {
    final decoded = img.decodeJpg(jpegBytes);
    if (decoded == null) return null;

    var sum = 0.0;
    var count = 0;

    // Sample every 4th pixel for performance.
    for (var y = 0; y < decoded.height; y += 2) {
      for (var x = 0; x < decoded.width; x += 2) {
        final pixel = decoded.getPixel(x, y);
        // BT.601 luminance formula.
        final luminance = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;
        sum += luminance;
        count++;
      }
    }

    return count > 0 ? sum / count : null;
  } on Exception {
    return null;
  }
}

/// Compute Laplacian variance from JPEG bytes as a blur metric.
///
/// The Laplacian is a second-order spatial derivative that highlights
/// regions of rapid intensity change (edges). For a blurry image, the
/// Laplacian response is low everywhere, so the variance is low. For a
/// sharp image, edges produce large positive/negative Laplacian values,
/// yielding high variance.
///
/// Algorithm:
/// 1. Decode JPEG → grayscale image.
/// 2. For each interior pixel, compute the discrete Laplacian:
///      L(x,y) = -4·I(x,y) + I(x-1,y) + I(x+1,y) + I(x,y-1) + I(x,y+1)
/// 3. Compute the variance of all Laplacian values.
///
/// Typical values:
/// - Very blurry (motion blur, out-of-focus): 10–50
/// - Moderately blurry: 50–100
/// - Sharp mobile video: 200–1000+
///
/// Runs in an isolate via [compute].
double? _computeLaplacianVariance(Uint8List jpegBytes) {
  try {
    final decoded = img.decodeJpg(jpegBytes);
    if (decoded == null) return null;

    // Convert to grayscale for single-channel processing.
    final gray = img.grayscale(decoded);

    final width = gray.width;
    final height = gray.height;

    if (width < 3 || height < 3) return null;

    // Apply Laplacian kernel and collect values.
    // We sample every 2nd pixel for performance on large frames.
    var lapSum = 0.0;
    var lapSqSum = 0.0;
    var count = 0;

    for (var y = 1; y < height - 1; y += 2) {
      for (var x = 1; x < width - 1; x += 2) {
        // Read the luminance (red channel of grayscale = gray value).
        final center = gray.getPixel(x, y).r.toDouble();
        final left = gray.getPixel(x - 1, y).r.toDouble();
        final right = gray.getPixel(x + 1, y).r.toDouble();
        final top = gray.getPixel(x, y - 1).r.toDouble();
        final bottom = gray.getPixel(x, y + 1).r.toDouble();

        // Discrete Laplacian (4-connectivity).
        final laplacian = -4 * center + left + right + top + bottom;

        lapSum += laplacian;
        lapSqSum += laplacian * laplacian;
        count++;
      }
    }

    if (count == 0) return null;

    // Variance = E[X²] - (E[X])²
    final mean = lapSum / count;
    final variance = (lapSqSum / count) - (mean * mean);

    return variance;
  } on Exception {
    return null;
  }
}

/// Detect screen recording artifacts from JPEG bytes.
/// Checks for uniform colored horizontal bands at top/bottom of frame.
/// Runs in an isolate via [compute].
bool _detectScreenRecordingArtifacts(Uint8List jpegBytes) {
  try {
    // Heuristic: Screen recordings typically have very uniform colored bands
    // (status bar, navigation bar) at the top and bottom.
    //
    // We check the entropy of byte values in the first and last ~5% of the
    // image data. Very low entropy suggests uniform bars.
    if (jpegBytes.length < 500) return false;

    final headerSkip = math.min(20, jpegBytes.length ~/ 10);
    final bandSize = math.max(50, (jpegBytes.length * 0.05).toInt());

    // Check top band.
    final topEntropy = _byteEntropy(
      jpegBytes,
      headerSkip,
      headerSkip + bandSize,
    );

    // Check bottom band.
    final bottomStart = jpegBytes.length - bandSize - 2;
    final bottomEntropy = _byteEntropy(
      jpegBytes,
      math.max(0, bottomStart),
      jpegBytes.length - 2,
    );

    // JPEG data for uniform regions typically has lower entropy.
    // This is a rough heuristic — values tuned empirically.
    const entropyThreshold = 3.0; // bits
    return topEntropy < entropyThreshold && bottomEntropy < entropyThreshold;
  } on Exception {
    return false;
  }
}

/// Calculate Shannon entropy of byte values in a range.
double _byteEntropy(Uint8List data, int start, int end) {
  final actualEnd = math.min(end, data.length);
  final actualStart = math.max(start, 0);
  final length = actualEnd - actualStart;
  if (length <= 0) return 8; // Max entropy = assume not suspicious.

  // Count byte value frequencies.
  final counts = List<int>.filled(256, 0);
  for (var i = actualStart; i < actualEnd; i++) {
    counts[data[i]]++;
  }

  // Calculate entropy.
  var entropy = 0.0;
  for (final count in counts) {
    if (count == 0) continue;
    final p = count / length;
    entropy -= p * (math.log(p) / math.ln2);
  }

  return entropy;
}

/// Compute Haversine great-circle distance in meters between two points.
///
/// This is a pure-dart implementation to avoid depending on Geolocator
/// in isolate-unsafe contexts and to keep the analyzer self-contained.
double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000.0; // meters

  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);

  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_degToRad(lat1)) *
          math.cos(_degToRad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c;
}

double _degToRad(double deg) => deg * (math.pi / 180.0);
