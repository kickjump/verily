/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    this.id,
    required this.authUserId,
    required this.username,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    required this.isPublic,
    this.socialLinks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    int? id,
    required _i1.UuidValue authUserId,
    required String username,
    required String displayName,
    String? bio,
    String? avatarUrl,
    required bool isPublic,
    String? socialLinks,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      username: jsonSerialization['username'] as String,
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      isPublic: jsonSerialization['isPublic'] as bool,
      socialLinks: jsonSerialization['socialLinks'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue authUserId;

  String username;

  String displayName;

  String? bio;

  String? avatarUrl;

  bool isPublic;

  String? socialLinks;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    String? username,
    String? displayName,
    String? bio,
    String? avatarUrl,
    bool? isPublic,
    String? socialLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'username': username,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'isPublic': isPublic,
      if (socialLinks != null) 'socialLinks': socialLinks,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required _i1.UuidValue authUserId,
    required String username,
    required String displayName,
    String? bio,
    String? avatarUrl,
    required bool isPublic,
    String? socialLinks,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         username: username,
         displayName: displayName,
         bio: bio,
         avatarUrl: avatarUrl,
         isPublic: isPublic,
         socialLinks: socialLinks,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    String? username,
    String? displayName,
    Object? bio = _Undefined,
    Object? avatarUrl = _Undefined,
    bool? isPublic,
    Object? socialLinks = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      isPublic: isPublic ?? this.isPublic,
      socialLinks: socialLinks is String? ? socialLinks : this.socialLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
