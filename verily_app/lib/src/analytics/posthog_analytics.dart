import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_core/verily_core.dart';

part 'posthog_analytics.g.dart';

/// PostHog API key configured via `--dart-define=POSTHOG_API_KEY=...`.
const _posthogApiKey = String.fromEnvironment('POSTHOG_API_KEY');

/// PostHog host configured via `--dart-define=POSTHOG_HOST=...`.
const _posthogHost = String.fromEnvironment(
  'POSTHOG_HOST',
  defaultValue: 'https://us.i.posthog.com',
);

/// Whether PostHog is configured with a valid API key.
bool get isPosthogConfigured => _posthogApiKey.isNotEmpty;

/// Initializes the PostHog SDK.
///
/// Must be called once during app startup, before [runApp].
/// No-ops if [_posthogApiKey] is empty (e.g. in tests or local dev).
Future<void> initPosthog() async {
  if (!isPosthogConfigured) {
    VLogger('PostHog').info(
      'PostHog API key not configured — analytics disabled. '
      'Pass --dart-define=POSTHOG_API_KEY=phc_... to enable.',
    );
    return;
  }

  final config = PostHogConfig(_posthogApiKey);
  config.host = _posthogHost;
  config.captureApplicationLifecycleEvents = true;
  config.debug = kDebugMode;

  await Posthog().setup(config);
  VLogger('PostHog').info('PostHog initialized (host: $_posthogHost)');
}

/// Provides the [Posthog] singleton for analytics operations.
///
/// Returns `null` when PostHog is not configured.
@Riverpod(keepAlive: true)
Posthog? posthogInstance(Ref ref) {
  if (!isPosthogConfigured) return null;
  return Posthog();
}

/// Extension on [Posthog] for common Verily tracking events.
extension VerilyAnalytics on Posthog {
  /// Identifies the user after authentication.
  Future<void> identifyUser({
    required String userId,
    String? email,
    String? walletAddress,
  }) async {
    await identify(
      userId: userId,
      userProperties: {
        if (email != null) 'email': email,
        if (walletAddress != null) 'wallet_address': walletAddress,
      },
    );
  }

  /// Resets the user identity on logout.
  Future<void> clearUser() async {
    await reset();
  }

  /// Tracks an action creation event.
  Future<void> trackActionCreated({
    required String actionType,
    String? category,
    bool isAiGenerated = false,
  }) async {
    await capture(
      eventName: 'action_created',
      properties: {
        'action_type': actionType,
        if (category != null) 'category': category,
        'is_ai_generated': isAiGenerated,
      },
    );
  }

  /// Tracks a verification submission event.
  Future<void> trackVerificationSubmitted({
    required int actionId,
    required String actionType,
  }) async {
    await capture(
      eventName: 'verification_submitted',
      properties: {'action_id': actionId, 'action_type': actionType},
    );
  }

  /// Tracks navigation to an action detail screen.
  Future<void> trackActionViewed({required int actionId}) async {
    await capture(
      eventName: 'action_viewed',
      properties: {'action_id': actionId},
    );
  }
}
