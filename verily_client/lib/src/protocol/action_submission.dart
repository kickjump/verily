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

abstract class ActionSubmission implements _i1.SerializableModel {
  ActionSubmission._({
    this.id,
    required this.actionId,
    required this.performerId,
    this.stepNumber,
    required this.videoUrl,
    this.videoDurationSeconds,
    this.deviceMetadata,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActionSubmission({
    int? id,
    required int actionId,
    required _i1.UuidValue performerId,
    int? stepNumber,
    required String videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionSubmissionImpl;

  factory ActionSubmission.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionSubmission(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      performerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['performerId'],
      ),
      stepNumber: jsonSerialization['stepNumber'] as int?,
      videoUrl: jsonSerialization['videoUrl'] as String,
      videoDurationSeconds: (jsonSerialization['videoDurationSeconds'] as num?)
          ?.toDouble(),
      deviceMetadata: jsonSerialization['deviceMetadata'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String,
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

  int actionId;

  _i1.UuidValue performerId;

  int? stepNumber;

  String videoUrl;

  double? videoDurationSeconds;

  String? deviceMetadata;

  double? latitude;

  double? longitude;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ActionSubmission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionSubmission copyWith({
    int? id,
    int? actionId,
    _i1.UuidValue? performerId,
    int? stepNumber,
    String? videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionSubmission',
      if (id != null) 'id': id,
      'actionId': actionId,
      'performerId': performerId.toJson(),
      if (stepNumber != null) 'stepNumber': stepNumber,
      'videoUrl': videoUrl,
      if (videoDurationSeconds != null)
        'videoDurationSeconds': videoDurationSeconds,
      if (deviceMetadata != null) 'deviceMetadata': deviceMetadata,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'status': status,
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

class _ActionSubmissionImpl extends ActionSubmission {
  _ActionSubmissionImpl({
    int? id,
    required int actionId,
    required _i1.UuidValue performerId,
    int? stepNumber,
    required String videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         actionId: actionId,
         performerId: performerId,
         stepNumber: stepNumber,
         videoUrl: videoUrl,
         videoDurationSeconds: videoDurationSeconds,
         deviceMetadata: deviceMetadata,
         latitude: latitude,
         longitude: longitude,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ActionSubmission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionSubmission copyWith({
    Object? id = _Undefined,
    int? actionId,
    _i1.UuidValue? performerId,
    Object? stepNumber = _Undefined,
    String? videoUrl,
    Object? videoDurationSeconds = _Undefined,
    Object? deviceMetadata = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActionSubmission(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      performerId: performerId ?? this.performerId,
      stepNumber: stepNumber is int? ? stepNumber : this.stepNumber,
      videoUrl: videoUrl ?? this.videoUrl,
      videoDurationSeconds: videoDurationSeconds is double?
          ? videoDurationSeconds
          : this.videoDurationSeconds,
      deviceMetadata: deviceMetadata is String?
          ? deviceMetadata
          : this.deviceMetadata,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
