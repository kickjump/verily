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

abstract class RewardPool implements _i1.SerializableModel {
  RewardPool._({
    this.id,
    required this.actionId,
    required this.creatorId,
    required this.rewardType,
    this.tokenMintAddress,
    required this.totalAmount,
    required this.remainingAmount,
    required this.perPersonAmount,
    this.maxRecipients,
    this.expiresAt,
    required this.platformFeePercent,
    required this.status,
    this.fundingTxSignature,
    required this.createdAt,
  });

  factory RewardPool({
    int? id,
    required int actionId,
    required _i1.UuidValue creatorId,
    required String rewardType,
    String? tokenMintAddress,
    required double totalAmount,
    required double remainingAmount,
    required double perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    required double platformFeePercent,
    required String status,
    String? fundingTxSignature,
    required DateTime createdAt,
  }) = _RewardPoolImpl;

  factory RewardPool.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardPool(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      creatorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      rewardType: jsonSerialization['rewardType'] as String,
      tokenMintAddress: jsonSerialization['tokenMintAddress'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      remainingAmount: (jsonSerialization['remainingAmount'] as num).toDouble(),
      perPersonAmount: (jsonSerialization['perPersonAmount'] as num).toDouble(),
      maxRecipients: jsonSerialization['maxRecipients'] as int?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      platformFeePercent: (jsonSerialization['platformFeePercent'] as num)
          .toDouble(),
      status: jsonSerialization['status'] as String,
      fundingTxSignature: jsonSerialization['fundingTxSignature'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  _i1.UuidValue creatorId;

  String rewardType;

  String? tokenMintAddress;

  double totalAmount;

  double remainingAmount;

  double perPersonAmount;

  int? maxRecipients;

  DateTime? expiresAt;

  double platformFeePercent;

  String status;

  String? fundingTxSignature;

  DateTime createdAt;

  /// Returns a shallow copy of this [RewardPool]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RewardPool copyWith({
    int? id,
    int? actionId,
    _i1.UuidValue? creatorId,
    String? rewardType,
    String? tokenMintAddress,
    double? totalAmount,
    double? remainingAmount,
    double? perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    double? platformFeePercent,
    String? status,
    String? fundingTxSignature,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardPool',
      if (id != null) 'id': id,
      'actionId': actionId,
      'creatorId': creatorId.toJson(),
      'rewardType': rewardType,
      if (tokenMintAddress != null) 'tokenMintAddress': tokenMintAddress,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'perPersonAmount': perPersonAmount,
      if (maxRecipients != null) 'maxRecipients': maxRecipients,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'platformFeePercent': platformFeePercent,
      'status': status,
      if (fundingTxSignature != null) 'fundingTxSignature': fundingTxSignature,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardPoolImpl extends RewardPool {
  _RewardPoolImpl({
    int? id,
    required int actionId,
    required _i1.UuidValue creatorId,
    required String rewardType,
    String? tokenMintAddress,
    required double totalAmount,
    required double remainingAmount,
    required double perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    required double platformFeePercent,
    required String status,
    String? fundingTxSignature,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actionId: actionId,
         creatorId: creatorId,
         rewardType: rewardType,
         tokenMintAddress: tokenMintAddress,
         totalAmount: totalAmount,
         remainingAmount: remainingAmount,
         perPersonAmount: perPersonAmount,
         maxRecipients: maxRecipients,
         expiresAt: expiresAt,
         platformFeePercent: platformFeePercent,
         status: status,
         fundingTxSignature: fundingTxSignature,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RewardPool]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RewardPool copyWith({
    Object? id = _Undefined,
    int? actionId,
    _i1.UuidValue? creatorId,
    String? rewardType,
    Object? tokenMintAddress = _Undefined,
    double? totalAmount,
    double? remainingAmount,
    double? perPersonAmount,
    Object? maxRecipients = _Undefined,
    Object? expiresAt = _Undefined,
    double? platformFeePercent,
    String? status,
    Object? fundingTxSignature = _Undefined,
    DateTime? createdAt,
  }) {
    return RewardPool(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      creatorId: creatorId ?? this.creatorId,
      rewardType: rewardType ?? this.rewardType,
      tokenMintAddress: tokenMintAddress is String?
          ? tokenMintAddress
          : this.tokenMintAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      perPersonAmount: perPersonAmount ?? this.perPersonAmount,
      maxRecipients: maxRecipients is int? ? maxRecipients : this.maxRecipients,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      platformFeePercent: platformFeePercent ?? this.platformFeePercent,
      status: status ?? this.status,
      fundingTxSignature: fundingTxSignature is String?
          ? fundingTxSignature
          : this.fundingTxSignature,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
