double calculateReadinessProgress({
  required int completedChecklistCount,
  required int checklistLength,
  required bool hasLocationLog,
  required bool captureAudioEnabled,
}) {
  final denominator = checklistLength + 2;
  if (denominator <= 0) {
    return 0;
  }

  final numerator =
      completedChecklistCount +
      (hasLocationLog ? 1 : 0) +
      (captureAudioEnabled ? 1 : 0);
  return (numerator / denominator).clamp(0.0, 1.0);
}

String formatCaptureDuration(int totalSeconds) {
  final normalized = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = (normalized ~/ 60).toString().padLeft(2, '0');
  final seconds = (normalized % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
