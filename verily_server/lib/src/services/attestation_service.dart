import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Service for device attestation and video nonce verification.
///
/// Handles:
/// - Challenge nonce generation for video recording sessions
/// - Play Integrity verification (Android)
/// - App Attest verification (iOS)
/// - Visual nonce verification in video via Gemini
///
/// All methods are static and accept a [Session] as the first parameter.
class AttestationService {
  AttestationService._();

  static final _log = VLogger('AttestationService');

  /// How long a challenge nonce is valid (5 minutes).
  static const _challengeTtl = Duration(minutes: 5);

  /// Characters used for visual nonces (easily readable on camera).
  static const _nonceChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  // ---------------------------------------------------------------------------
  // Challenge nonce
  // ---------------------------------------------------------------------------

  /// Creates a challenge nonce for a video recording session.
  ///
  /// The nonce must be displayed during recording and will be verified
  /// by Gemini in the submitted video.
  static Future<AttestationChallenge> createChallenge(
    Session session, {
    required UuidValue userId,
    required int actionId,
  }) async {
    // Verify action exists.
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action $actionId not found');
    }

    // Expire any unused challenges for this user+action.
    final existing = await AttestationChallenge.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.actionId.equals(actionId) &
          t.used.equals(false),
    );
    for (final old in existing) {
      old.used = true;
      await AttestationChallenge.db.updateRow(session, old);
    }

    final now = DateTime.now().toUtc();
    final nonce = _generateNonce(6);
    final visualNonce = _generateVisualNonceDescription(nonce);

    final challenge = AttestationChallenge(
      userId: userId,
      actionId: actionId,
      nonce: nonce,
      visualNonce: visualNonce,
      expiresAt: now.add(_challengeTtl),
      used: false,
      createdAt: now,
    );

    final inserted =
        await AttestationChallenge.db.insertRow(session, challenge);
    _log.info(
      'Created attestation challenge for user $userId, '
      'action $actionId: $nonce',
    );
    return inserted;
  }

  /// Validates and consumes a challenge nonce.
  ///
  /// Returns the challenge if valid, throws if expired or already used.
  static Future<AttestationChallenge> consumeChallenge(
    Session session, {
    required String nonce,
  }) async {
    final challenges = await AttestationChallenge.db.find(
      session,
      where: (t) => t.nonce.equals(nonce),
      limit: 1,
    );

    if (challenges.isEmpty) {
      throw NotFoundException('Challenge not found');
    }

    final challenge = challenges.first;

    if (challenge.used) {
      throw ValidationException('Challenge has already been used');
    }

    if (DateTime.now().toUtc().isAfter(challenge.expiresAt)) {
      throw ValidationException('Challenge has expired');
    }

    // Mark as used.
    challenge.used = true;
    await AttestationChallenge.db.updateRow(session, challenge);
    return challenge;
  }

  // ---------------------------------------------------------------------------
  // Platform attestation
  // ---------------------------------------------------------------------------

  /// Verifies a Google Play Integrity token (Android).
  ///
  /// In production, this calls the Play Integrity API to verify the token.
  /// For MVP, we record the attestation and mark as verified.
  static Future<DeviceAttestation> verifyPlayIntegrity(
    Session session, {
    required int submissionId,
    required String integrityToken,
  }) async {
    // TODO: Call Google Play Integrity API to verify token:
    // POST https://playintegrity.googleapis.com/v1/{packageName}:decodeIntegrityToken
    // With the integrityToken in the request body.
    //
    // Verify:
    // - requestDetails.requestPackageName matches our app
    // - requestDetails.nonce matches our challenge nonce
    // - appIntegrity.appRecognitionVerdict == "PLAY_RECOGNIZED"
    // - deviceIntegrity.deviceRecognitionVerdict contains "MEETS_DEVICE_INTEGRITY"

    _log.info(
      'Play Integrity verification for submission $submissionId (stub)',
    );

    final attestation = DeviceAttestation(
      submissionId: submissionId,
      platform: 'android',
      attestationType: AttestationType.playIntegrity.value,
      verified: true, // TODO: Actually verify
      rawResult: jsonEncode({'token': integrityToken, 'stub': true}),
      createdAt: DateTime.now().toUtc(),
    );

    return DeviceAttestation.db.insertRow(session, attestation);
  }

  /// Verifies an Apple App Attest assertion (iOS).
  ///
  /// In production, this verifies the attestation object against Apple's
  /// servers.
  static Future<DeviceAttestation> verifyAppAttest(
    Session session, {
    required int submissionId,
    required String attestationObject,
    required String keyId,
  }) async {
    // TODO: Verify Apple App Attest:
    // 1. Decode CBOR attestation object
    // 2. Verify x5c certificate chain against Apple root CA
    // 3. Verify nonce in attestation matches our challenge
    // 4. Verify credCert public key matches keyId
    // 5. Store keyId for future assertion verification

    _log.info('App Attest verification for submission $submissionId (stub)');

    final attestation = DeviceAttestation(
      submissionId: submissionId,
      platform: 'ios',
      attestationType: AttestationType.appAttest.value,
      verified: true, // TODO: Actually verify
      rawResult: jsonEncode({
        'keyId': keyId,
        'stub': true,
      }),
      createdAt: DateTime.now().toUtc(),
    );

    return DeviceAttestation.db.insertRow(session, attestation);
  }

  /// Gets the attestation record for a submission.
  static Future<DeviceAttestation?> getBySubmission(
    Session session, {
    required int submissionId,
  }) async {
    final results = await DeviceAttestation.db.find(
      session,
      where: (t) => t.submissionId.equals(submissionId),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Generates a random alphanumeric nonce.
  static String _generateNonce(int length) {
    final random = Random.secure();
    return List.generate(
      length,
      (_) => _nonceChars[random.nextInt(_nonceChars.length)],
    ).join();
  }

  /// Creates a human-readable description of how to display the nonce.
  static String _generateVisualNonceDescription(String nonce) {
    return 'Display the code "$nonce" on screen during your recording. '
        'Hold it up so it is clearly visible in the video.';
  }
}
