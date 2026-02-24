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

abstract class UserFollow implements _i1.SerializableModel {
  UserFollow._({
    this.id,
    required this.followerId,
    required this.followedId,
    required this.createdAt,
  });

  factory UserFollow({
    int? id,
    required _i1.UuidValue followerId,
    required _i1.UuidValue followedId,
    required DateTime createdAt,
  }) = _UserFollowImpl;

  factory UserFollow.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFollow(
      id: jsonSerialization['id'] as int?,
      followerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['followerId'],
      ),
      followedId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['followedId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue followerId;

  _i1.UuidValue followedId;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserFollow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserFollow copyWith({
    int? id,
    _i1.UuidValue? followerId,
    _i1.UuidValue? followedId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserFollow',
      if (id != null) 'id': id,
      'followerId': followerId.toJson(),
      'followedId': followedId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFollowImpl extends UserFollow {
  _UserFollowImpl({
    int? id,
    required _i1.UuidValue followerId,
    required _i1.UuidValue followedId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         followerId: followerId,
         followedId: followedId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserFollow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserFollow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? followerId,
    _i1.UuidValue? followedId,
    DateTime? createdAt,
  }) {
    return UserFollow(
      id: id is int? ? id : this.id,
      followerId: followerId ?? this.followerId,
      followedId: followedId ?? this.followedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
