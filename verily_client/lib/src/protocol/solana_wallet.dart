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

abstract class SolanaWallet implements _i1.SerializableModel {
  SolanaWallet._({
    this.id,
    required this.userId,
    required this.publicKey,
    required this.walletType,
    required this.isDefault,
    this.label,
    required this.createdAt,
  });

  factory SolanaWallet({
    int? id,
    required _i1.UuidValue userId,
    required String publicKey,
    required String walletType,
    required bool isDefault,
    String? label,
    required DateTime createdAt,
  }) = _SolanaWalletImpl;

  factory SolanaWallet.fromJson(Map<String, dynamic> jsonSerialization) {
    return SolanaWallet(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      publicKey: jsonSerialization['publicKey'] as String,
      walletType: jsonSerialization['walletType'] as String,
      isDefault: jsonSerialization['isDefault'] as bool,
      label: jsonSerialization['label'] as String?,
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

  String publicKey;

  String walletType;

  bool isDefault;

  String? label;

  DateTime createdAt;

  /// Returns a shallow copy of this [SolanaWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SolanaWallet copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? publicKey,
    String? walletType,
    bool? isDefault,
    String? label,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SolanaWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'publicKey': publicKey,
      'walletType': walletType,
      'isDefault': isDefault,
      if (label != null) 'label': label,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SolanaWalletImpl extends SolanaWallet {
  _SolanaWalletImpl({
    int? id,
    required _i1.UuidValue userId,
    required String publicKey,
    required String walletType,
    required bool isDefault,
    String? label,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         publicKey: publicKey,
         walletType: walletType,
         isDefault: isDefault,
         label: label,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SolanaWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SolanaWallet copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? publicKey,
    String? walletType,
    bool? isDefault,
    Object? label = _Undefined,
    DateTime? createdAt,
  }) {
    return SolanaWallet(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      publicKey: publicKey ?? this.publicKey,
      walletType: walletType ?? this.walletType,
      isDefault: isDefault ?? this.isDefault,
      label: label is String? ? label : this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
