import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'user_profile_provider.g.dart';

/// Fetches the authenticated user's profile.
@riverpod
Future<UserProfile> currentUserProfile(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  return client.userProfile.get();
}

/// Fetches a user profile by username.
@riverpod
Future<UserProfile?> userProfileByUsername(Ref ref, String username) async {
  final client = ref.watch(serverpodClientProvider);
  return client.userProfile.getByUsername(username);
}

/// Searches for user profiles.
@riverpod
Future<List<UserProfile>> searchUserProfiles(Ref ref, String query) async {
  if (query.trim().isEmpty) return [];
  final client = ref.watch(serverpodClientProvider);
  return client.userProfile.search(query);
}
