import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global test configuration for all widget tests in `verily_app`.
///
/// - Disables Google Fonts runtime fetching to prevent network requests.
/// - Disables `flutter_animate` animations to prevent pending timer
///   assertions (`'!timersPending'` failures).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  Animate.restartOnHotReload = false;

  await testMain();
}
