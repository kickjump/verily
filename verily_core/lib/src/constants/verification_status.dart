/// Status of a video submission verification.
enum VerificationStatus {
  /// Submission received, awaiting processing.
  pending('pending', 'Pending'),

  /// Gemini AI is analyzing the video.
  processing('processing', 'Processing'),

  /// Video passed verification.
  passed('passed', 'Passed'),

  /// Video failed verification.
  failed('failed', 'Failed'),

  /// An error occurred during verification.
  error('error', 'Error');

  const VerificationStatus(this.value, this.displayName);

  /// The serialized value stored in the database.
  final String value;

  /// Human-readable display name.
  final String displayName;

  /// Parses a [VerificationStatus] from its string [value].
  static VerificationStatus fromValue(String value) {
    return VerificationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () =>
          throw ArgumentError('Unknown VerificationStatus: $value'),
    );
  }
}
