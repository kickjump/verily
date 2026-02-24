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

abstract class AttestationChallenge implements _i1.SerializableModel {
  AttestationChallenge._({
    this.id,
    required this.userId,
    required this.actionId,
    required this.nonce,
    this.visualNonce,
    required this.expiresAt,
    required this.used,
    required this.createdAt,
  });

  factory AttestationChallenge({
    int? id,
    required _i1.UuidValue userId,
    required int actionId,
    required String nonce,
    String? visualNonce,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) = _AttestationChallengeImpl;

  factory AttestationChallenge.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AttestationChallenge(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      actionId: jsonSerialization['actionId'] as int,
      nonce: jsonSerialization['nonce'] as String,
      visualNonce: jsonSerialization['visualNonce'] as String?,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      used: jsonSerialization['used'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  int actionId;

  String nonce;

  String? visualNonce;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  /// Returns a shallow copy of this [AttestationChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AttestationChallenge copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? actionId,
    String? nonce,
    String? visualNonce,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttestationChallenge',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'actionId': actionId,
      'nonce': nonce,
      if (visualNonce != null) 'visualNonce': visualNonce,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttestationChallengeImpl extends AttestationChallenge {
  _AttestationChallengeImpl({
    int? id,
    required _i1.UuidValue userId,
    required int actionId,
    required String nonce,
    String? visualNonce,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         actionId: actionId,
         nonce: nonce,
         visualNonce: visualNonce,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AttestationChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AttestationChallenge copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? actionId,
    String? nonce,
    Object? visualNonce = _Undefined,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return AttestationChallenge(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      actionId: actionId ?? this.actionId,
      nonce: nonce ?? this.nonce,
      visualNonce: visualNonce is String? ? visualNonce : this.visualNonce,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
