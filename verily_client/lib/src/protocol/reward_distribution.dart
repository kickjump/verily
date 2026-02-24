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

abstract class RewardDistribution implements _i1.SerializableModel {
  RewardDistribution._({
    this.id,
    required this.rewardPoolId,
    required this.recipientId,
    required this.submissionId,
    required this.amount,
    this.txSignature,
    required this.status,
    required this.createdAt,
  });

  factory RewardDistribution({
    int? id,
    required int rewardPoolId,
    required _i1.UuidValue recipientId,
    required int submissionId,
    required double amount,
    String? txSignature,
    required String status,
    required DateTime createdAt,
  }) = _RewardDistributionImpl;

  factory RewardDistribution.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardDistribution(
      id: jsonSerialization['id'] as int?,
      rewardPoolId: jsonSerialization['rewardPoolId'] as int,
      recipientId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['recipientId'],
      ),
      submissionId: jsonSerialization['submissionId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      txSignature: jsonSerialization['txSignature'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int rewardPoolId;

  _i1.UuidValue recipientId;

  int submissionId;

  double amount;

  String? txSignature;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [RewardDistribution]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RewardDistribution copyWith({
    int? id,
    int? rewardPoolId,
    _i1.UuidValue? recipientId,
    int? submissionId,
    double? amount,
    String? txSignature,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardDistribution',
      if (id != null) 'id': id,
      'rewardPoolId': rewardPoolId,
      'recipientId': recipientId.toJson(),
      'submissionId': submissionId,
      'amount': amount,
      if (txSignature != null) 'txSignature': txSignature,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardDistributionImpl extends RewardDistribution {
  _RewardDistributionImpl({
    int? id,
    required int rewardPoolId,
    required _i1.UuidValue recipientId,
    required int submissionId,
    required double amount,
    String? txSignature,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         rewardPoolId: rewardPoolId,
         recipientId: recipientId,
         submissionId: submissionId,
         amount: amount,
         txSignature: txSignature,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RewardDistribution]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RewardDistribution copyWith({
    Object? id = _Undefined,
    int? rewardPoolId,
    _i1.UuidValue? recipientId,
    int? submissionId,
    double? amount,
    Object? txSignature = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return RewardDistribution(
      id: id is int? ? id : this.id,
      rewardPoolId: rewardPoolId ?? this.rewardPoolId,
      recipientId: recipientId ?? this.recipientId,
      submissionId: submissionId ?? this.submissionId,
      amount: amount ?? this.amount,
      txSignature: txSignature is String? ? txSignature : this.txSignature,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
