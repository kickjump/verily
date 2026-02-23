import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../generated/protocol.dart';
import '../services/attestation_service.dart';

/// Endpoint for device attestation and video nonce management.
///
/// Handles challenge nonce creation for video recording sessions and
/// platform attestation submission (Play Integrity, App Attest).
class AttestationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a challenge nonce for a video recording session.
  ///
  /// The nonce must be displayed during recording and will be verified
  /// by Gemini in the submitted video.
  Future<AttestationChallenge> createChallenge(
    Session session,
    int actionId,
  ) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    return AttestationService.createChallenge(
      session,
      userId: userId,
      actionId: actionId,
    );
  }

  /// Submits a platform attestation for a video submission.
  ///
  /// [platform] should be 'android' or 'ios'.
  /// [token] is the Play Integrity token (Android) or App Attest object (iOS).
  Future<DeviceAttestation> submitAttestation(
    Session session,
    int submissionId,
    String platform,
    String token, {
    String? keyId,
  }) async {
    if (platform == 'android') {
      return AttestationService.verifyPlayIntegrity(
        session,
        submissionId: submissionId,
        integrityToken: token,
      );
    } else if (platform == 'ios') {
      return AttestationService.verifyAppAttest(
        session,
        submissionId: submissionId,
        attestationObject: token,
        keyId: keyId ?? '',
      );
    }
    throw ArgumentError('Unsupported platform: $platform');
  }
}
