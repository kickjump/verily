/// Test fixtures used across Patrol E2E tests.
abstract final class TestData {
  // Auth credentials
  static const testEmail = 'test@verily.fun';
  static const testPassword = 'TestPassword123!';
  static const testUsername = 'testuser';
  static const testDisplayName = 'Test User';

  // Actions
  static const testActionTitle = 'Do 10 Press-ups';
  static const testActionCategory = 'Fitness';
  static const testActionDescription =
      'Complete 10 press-ups and submit a video for verification.';

  // Profile placeholder data (matches the hardcoded values in ProfileScreen)
  static const profileDisplayName = 'John Doe';
  static const profileUsername = '@johndoe';
  static const profileCreatedCount = '12';
  static const profileCompletedCount = '28';
  static const profileBadgeCount = '7';
}
