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

abstract class DeviceAttestation implements _i1.SerializableModel {
  DeviceAttestation._({
    this.id,
    required this.submissionId,
    required this.platform,
    required this.attestationType,
    required this.verified,
    this.rawResult,
    required this.createdAt,
  });

  factory DeviceAttestation({
    int? id,
    required int submissionId,
    required String platform,
    required String attestationType,
    required bool verified,
    String? rawResult,
    required DateTime createdAt,
  }) = _DeviceAttestationImpl;

  factory DeviceAttestation.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceAttestation(
      id: jsonSerialization['id'] as int?,
      submissionId: jsonSerialization['submissionId'] as int,
      platform: jsonSerialization['platform'] as String,
      attestationType: jsonSerialization['attestationType'] as String,
      verified: jsonSerialization['verified'] as bool,
      rawResult: jsonSerialization['rawResult'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int submissionId;

  String platform;

  String attestationType;

  bool verified;

  String? rawResult;

  DateTime createdAt;

  /// Returns a shallow copy of this [DeviceAttestation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceAttestation copyWith({
    int? id,
    int? submissionId,
    String? platform,
    String? attestationType,
    bool? verified,
    String? rawResult,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceAttestation',
      if (id != null) 'id': id,
      'submissionId': submissionId,
      'platform': platform,
      'attestationType': attestationType,
      'verified': verified,
      if (rawResult != null) 'rawResult': rawResult,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceAttestationImpl extends DeviceAttestation {
  _DeviceAttestationImpl({
    int? id,
    required int submissionId,
    required String platform,
    required String attestationType,
    required bool verified,
    String? rawResult,
    required DateTime createdAt,
  }) : super._(
         id: id,
         submissionId: submissionId,
         platform: platform,
         attestationType: attestationType,
         verified: verified,
         rawResult: rawResult,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DeviceAttestation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceAttestation copyWith({
    Object? id = _Undefined,
    int? submissionId,
    String? platform,
    String? attestationType,
    bool? verified,
    Object? rawResult = _Undefined,
    DateTime? createdAt,
  }) {
    return DeviceAttestation(
      id: id is int? ? id : this.id,
      submissionId: submissionId ?? this.submissionId,
      platform: platform ?? this.platform,
      attestationType: attestationType ?? this.attestationType,
      verified: verified ?? this.verified,
      rawResult: rawResult is String? ? rawResult : this.rawResult,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
