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

abstract class UserReward implements _i1.SerializableModel {
  UserReward._({
    this.id,
    required this.userId,
    required this.rewardId,
    this.submissionId,
    required this.earnedAt,
  });

  factory UserReward({
    int? id,
    required _i1.UuidValue userId,
    required int rewardId,
    int? submissionId,
    required DateTime earnedAt,
  }) = _UserRewardImpl;

  factory UserReward.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserReward(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      rewardId: jsonSerialization['rewardId'] as int,
      submissionId: jsonSerialization['submissionId'] as int?,
      earnedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['earnedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  int rewardId;

  int? submissionId;

  DateTime earnedAt;

  /// Returns a shallow copy of this [UserReward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserReward copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? rewardId,
    int? submissionId,
    DateTime? earnedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserReward',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'rewardId': rewardId,
      if (submissionId != null) 'submissionId': submissionId,
      'earnedAt': earnedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRewardImpl extends UserReward {
  _UserRewardImpl({
    int? id,
    required _i1.UuidValue userId,
    required int rewardId,
    int? submissionId,
    required DateTime earnedAt,
  }) : super._(
         id: id,
         userId: userId,
         rewardId: rewardId,
         submissionId: submissionId,
         earnedAt: earnedAt,
       );

  /// Returns a shallow copy of this [UserReward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserReward copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? rewardId,
    Object? submissionId = _Undefined,
    DateTime? earnedAt,
  }) {
    return UserReward(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      rewardId: rewardId ?? this.rewardId,
      submissionId: submissionId is int? ? submissionId : this.submissionId,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}
