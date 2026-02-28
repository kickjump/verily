import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_test/integration_test.dart';

import 'patrol_helpers.dart';

const _captureScreenshotsFromDefine = bool.fromEnvironment(
  'CAPTURE_UI_SCREENSHOTS',
);

bool get _shouldCaptureScreenshots =>
    _captureScreenshotsFromDefine ||
    Platform.environment['CAPTURE_UI_SCREENSHOTS'] == 'true';

Future<Directory>? _screenshotDirectoryFuture;

Future<Directory> _resolveScreenshotDirectory() async {
  final configuredPath = Platform.environment['PATROL_SCREENSHOT_DIR'];
  if (configuredPath != null && configuredPath.isNotEmpty) {
    final configuredDirectory = Directory(configuredPath);
    await configuredDirectory.create(recursive: true);
    return configuredDirectory;
  }

  final localDirectory = Directory(
    'artifacts${Platform.pathSeparator}screenshots',
  );
  try {
    await localDirectory.create(recursive: true);
    return localDirectory;
  } on FileSystemException {
    final tempRoot = await Directory.systemTemp.createTemp(
      'verily-patrol-screenshots-',
    );
    final tempDirectory = Directory(
      '${tempRoot.path}${Platform.pathSeparator}screenshots',
    );
    await tempDirectory.create(recursive: true);
    return tempDirectory;
  }
}

Future<void> _writeScreenshot(String name, List<int> bytes) async {
  final directory = await (_screenshotDirectoryFuture ??=
      _resolveScreenshotDirectory());
  final file = File('${directory.path}${Platform.pathSeparator}$name.png');
  await file.writeAsBytes(bytes, flush: true);
}

Future<void> _captureFromBoundary(String name, WidgetTester tester) async {
  final boundaryFinder = find.byKey(integrationScreenshotBoundaryKey);
  if (boundaryFinder.evaluate().isEmpty) {
    return;
  }

  final boundary = tester.renderObject<RenderRepaintBoundary>(boundaryFinder);
  final image = await boundary.toImage(pixelRatio: 2);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) {
    return;
  }

  await _writeScreenshot(name, data.buffer.asUint8List());
}

Future<void> maybeCapturePatrolScreenshot(
  String name,
  WidgetTester tester, [
  IntegrationTestWidgetsFlutterBinding? binding,
]) async {
  if (!_shouldCaptureScreenshots) {
    return;
  }

  IntegrationTestWidgetsFlutterBinding? activeBinding = binding;
  if (activeBinding == null) {
    final currentBinding = WidgetsBinding.instance;
    if (currentBinding is IntegrationTestWidgetsFlutterBinding) {
      activeBinding = currentBinding;
    }
  }

  if (activeBinding != null) {
    try {
      final bytes = await activeBinding.takeScreenshot(name);
      await _writeScreenshot(name, bytes);
      return;
    } on MissingPluginException {
      // Fall back to boundary capture when native screenshot plugin isn't
      // available (common in simulator/hosted runs).
    }
  }

  await _captureFromBoundary(name, tester);
}
