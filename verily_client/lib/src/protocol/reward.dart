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

abstract class Reward implements _i1.SerializableModel {
  Reward._({
    this.id,
    required this.rewardType,
    required this.name,
    this.description,
    this.iconUrl,
    this.pointValue,
    required this.actionId,
  });

  factory Reward({
    int? id,
    required String rewardType,
    required String name,
    String? description,
    String? iconUrl,
    int? pointValue,
    required int actionId,
  }) = _RewardImpl;

  factory Reward.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reward(
      id: jsonSerialization['id'] as int?,
      rewardType: jsonSerialization['rewardType'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      iconUrl: jsonSerialization['iconUrl'] as String?,
      pointValue: jsonSerialization['pointValue'] as int?,
      actionId: jsonSerialization['actionId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String rewardType;

  String name;

  String? description;

  String? iconUrl;

  int? pointValue;

  int actionId;

  /// Returns a shallow copy of this [Reward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reward copyWith({
    int? id,
    String? rewardType,
    String? name,
    String? description,
    String? iconUrl,
    int? pointValue,
    int? actionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reward',
      if (id != null) 'id': id,
      'rewardType': rewardType,
      'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (pointValue != null) 'pointValue': pointValue,
      'actionId': actionId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardImpl extends Reward {
  _RewardImpl({
    int? id,
    required String rewardType,
    required String name,
    String? description,
    String? iconUrl,
    int? pointValue,
    required int actionId,
  }) : super._(
         id: id,
         rewardType: rewardType,
         name: name,
         description: description,
         iconUrl: iconUrl,
         pointValue: pointValue,
         actionId: actionId,
       );

  /// Returns a shallow copy of this [Reward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reward copyWith({
    Object? id = _Undefined,
    String? rewardType,
    String? name,
    Object? description = _Undefined,
    Object? iconUrl = _Undefined,
    Object? pointValue = _Undefined,
    int? actionId,
  }) {
    return Reward(
      id: id is int? ? id : this.id,
      rewardType: rewardType ?? this.rewardType,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      iconUrl: iconUrl is String? ? iconUrl : this.iconUrl,
      pointValue: pointValue is int? ? pointValue : this.pointValue,
      actionId: actionId ?? this.actionId,
    );
  }
}
