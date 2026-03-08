import 'dart:convert';

import 'package:crypto/crypto.dart';
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
/// Must be called once during app startup, before `runApp`.
/// No-ops if the PostHog API key is empty (e.g. in tests or local dev).
Future<void> initPosthog() async {
  if (!isPosthogConfigured) {
    VLogger('PostHog').info(
      'PostHog API key not configured — analytics disabled. '
      'Pass --dart-define=POSTHOG_API_KEY=phc_... to enable.',
    );
    return;
  }

  final config = PostHogConfig(_posthogApiKey)
    ..host = _posthogHost
    ..captureApplicationLifecycleEvents = true
    ..debug = kDebugMode;

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

String _sha256Hex(String value) {
  final bytes = utf8.encode(value.trim().toLowerCase());
  return sha256.convert(bytes).toString();
}

Map<String, Object> _identifyPropertiesAllowlist({
  String? email,
  String? walletAddress,
}) {
  final properties = <String, Object>{};

  if (email != null && email.trim().isNotEmpty) {
    properties['email_hash'] = _sha256Hex(email);
  }

  if (walletAddress != null && walletAddress.trim().isNotEmpty) {
    properties['wallet_address_hash'] = _sha256Hex(walletAddress);
  }

  return properties;
}

Map<String, Object> _searchPropertiesAllowlist(String query) {
  final normalized = query.trim();
  return {
    'query_present': normalized.isNotEmpty,
    'query_length': normalized.length,
  };
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
      userProperties: _identifyPropertiesAllowlist(
        email: email,
        walletAddress: walletAddress,
      ),
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

  /// Tracks a search query with sanitized, allowlisted properties only.
  Future<void> trackSearch({required String query}) async {
    await capture(
      eventName: 'search_performed',
      properties: _searchPropertiesAllowlist(query),
    );
  }

  /// Tracks a reward pool creation.
  Future<void> trackRewardPoolCreated({
    required int actionId,
    required String rewardType,
  }) async {
    await capture(
      eventName: 'reward_pool_created',
      properties: {'action_id': actionId, 'reward_type': rewardType},
    );
  }
}
