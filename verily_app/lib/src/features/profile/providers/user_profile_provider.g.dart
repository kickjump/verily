// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the authenticated user's profile.

@ProviderFor(currentUserProfile)
final currentUserProfileProvider = CurrentUserProfileProvider._();

/// Fetches the authenticated user's profile.

final class CurrentUserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile>,
          UserProfile,
          FutureOr<UserProfile>
        >
    with $FutureModifier<UserProfile>, $FutureProvider<UserProfile> {
  /// Fetches the authenticated user's profile.
  CurrentUserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserProfileHash();

  @$internal
  @override
  $FutureProviderElement<UserProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile> create(Ref ref) {
    return currentUserProfile(ref);
  }
}

String _$currentUserProfileHash() =>
    r'e4f9a7a7f40ee7f0fd76d96846781032cd676a8d';

/// Fetches a user profile by username.

@ProviderFor(userProfileByUsername)
final userProfileByUsernameProvider = UserProfileByUsernameFamily._();

/// Fetches a user profile by username.

final class UserProfileByUsernameProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile?>,
          UserProfile?,
          FutureOr<UserProfile?>
        >
    with $FutureModifier<UserProfile?>, $FutureProvider<UserProfile?> {
  /// Fetches a user profile by username.
  UserProfileByUsernameProvider._({
    required UserProfileByUsernameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileByUsernameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileByUsernameHash();

  @override
  String toString() {
    return r'userProfileByUsernameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile?> create(Ref ref) {
    final argument = this.argument as String;
    return userProfileByUsername(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileByUsernameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileByUsernameHash() =>
    r'f029b29153c9b3382cd1e99d4cab0aaede890ccf';

/// Fetches a user profile by username.

final class UserProfileByUsernameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserProfile?>, String> {
  UserProfileByUsernameFamily._()
    : super(
        retry: null,
        name: r'userProfileByUsernameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a user profile by username.

  UserProfileByUsernameProvider call(String username) =>
      UserProfileByUsernameProvider._(argument: username, from: this);

  @override
  String toString() => r'userProfileByUsernameProvider';
}

/// Searches for user profiles.

@ProviderFor(searchUserProfiles)
final searchUserProfilesProvider = SearchUserProfilesFamily._();

/// Searches for user profiles.

final class SearchUserProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserProfile>>,
          List<UserProfile>,
          FutureOr<List<UserProfile>>
        >
    with
        $FutureModifier<List<UserProfile>>,
        $FutureProvider<List<UserProfile>> {
  /// Searches for user profiles.
  SearchUserProfilesProvider._({
    required SearchUserProfilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchUserProfilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchUserProfilesHash();

  @override
  String toString() {
    return r'searchUserProfilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserProfile>> create(Ref ref) {
    final argument = this.argument as String;
    return searchUserProfiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUserProfilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchUserProfilesHash() =>
    r'cbdb5f3cd73027241b9e8fdcca9f19a6e63e4f3e';

/// Searches for user profiles.

final class SearchUserProfilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserProfile>>, String> {
  SearchUserProfilesFamily._()
    : super(
        retry: null,
        name: r'searchUserProfilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Searches for user profiles.

  SearchUserProfilesProvider call(String query) =>
      SearchUserProfilesProvider._(argument: query, from: this);

  @override
  String toString() => r'searchUserProfilesProvider';
}
