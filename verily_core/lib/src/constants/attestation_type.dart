/// Platform attestation types for device verification.
enum AttestationType {
  /// Google Play Integrity API (Android).
  playIntegrity('play_integrity'),

  /// Apple App Attest (iOS).
  appAttest('app_attest'),

  /// No attestation available (web/desktop).
  none('none');

  const AttestationType(this.value);
  final String value;

  static AttestationType fromValue(String value) {
    return AttestationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown AttestationType: $value'),
    );
  }
}
