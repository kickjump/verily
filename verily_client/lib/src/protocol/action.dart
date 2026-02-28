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

abstract class Action implements _i1.SerializableModel {
  Action._({
    this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.actionType,
    required this.status,
    this.locationId,
    this.categoryId,
    this.totalSteps,
    this.stepOrdering,
    this.intervalDays,
    this.habitDurationDays,
    this.habitFrequencyPerWeek,
    this.habitTotalRequired,
    this.maxPerformers,
    this.referenceImages,
    required this.verificationCriteria,
    this.tags,
    this.expiresAt,
    this.locationRadius,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Action({
    int? id,
    required String title,
    required String description,
    required _i1.UuidValue creatorId,
    required String actionType,
    required String status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    required String verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      creatorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      actionType: jsonSerialization['actionType'] as String,
      status: jsonSerialization['status'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      categoryId: jsonSerialization['categoryId'] as int?,
      totalSteps: jsonSerialization['totalSteps'] as int?,
      stepOrdering: jsonSerialization['stepOrdering'] as String?,
      intervalDays: jsonSerialization['intervalDays'] as int?,
      habitDurationDays: jsonSerialization['habitDurationDays'] as int?,
      habitFrequencyPerWeek: jsonSerialization['habitFrequencyPerWeek'] as int?,
      habitTotalRequired: jsonSerialization['habitTotalRequired'] as int?,
      maxPerformers: jsonSerialization['maxPerformers'] as int?,
      referenceImages: jsonSerialization['referenceImages'] as String?,
      verificationCriteria: jsonSerialization['verificationCriteria'] as String,
      tags: jsonSerialization['tags'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      locationRadius: (jsonSerialization['locationRadius'] as num?)?.toDouble(),
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

  String title;

  String description;

  _i1.UuidValue creatorId;

  String actionType;

  String status;

  int? locationId;

  int? categoryId;

  int? totalSteps;

  String? stepOrdering;

  int? intervalDays;

  int? habitDurationDays;

  int? habitFrequencyPerWeek;

  int? habitTotalRequired;

  int? maxPerformers;

  String? referenceImages;

  String verificationCriteria;

  String? tags;

  DateTime? expiresAt;

  double? locationRadius;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    String? title,
    String? description,
    _i1.UuidValue? creatorId,
    String? actionType,
    String? status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    String? verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Action',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId.toJson(),
      'actionType': actionType,
      'status': status,
      if (locationId != null) 'locationId': locationId,
      if (categoryId != null) 'categoryId': categoryId,
      if (totalSteps != null) 'totalSteps': totalSteps,
      if (stepOrdering != null) 'stepOrdering': stepOrdering,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (habitDurationDays != null) 'habitDurationDays': habitDurationDays,
      if (habitFrequencyPerWeek != null)
        'habitFrequencyPerWeek': habitFrequencyPerWeek,
      if (habitTotalRequired != null) 'habitTotalRequired': habitTotalRequired,
      if (maxPerformers != null) 'maxPerformers': maxPerformers,
      if (referenceImages != null) 'referenceImages': referenceImages,
      'verificationCriteria': verificationCriteria,
      if (tags != null) 'tags': tags,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (locationRadius != null) 'locationRadius': locationRadius,
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

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required String title,
    required String description,
    required _i1.UuidValue creatorId,
    required String actionType,
    required String status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    required String verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         description: description,
         creatorId: creatorId,
         actionType: actionType,
         status: status,
         locationId: locationId,
         categoryId: categoryId,
         totalSteps: totalSteps,
         stepOrdering: stepOrdering,
         intervalDays: intervalDays,
         habitDurationDays: habitDurationDays,
         habitFrequencyPerWeek: habitFrequencyPerWeek,
         habitTotalRequired: habitTotalRequired,
         maxPerformers: maxPerformers,
         referenceImages: referenceImages,
         verificationCriteria: verificationCriteria,
         tags: tags,
         expiresAt: expiresAt,
         locationRadius: locationRadius,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    _i1.UuidValue? creatorId,
    String? actionType,
    String? status,
    Object? locationId = _Undefined,
    Object? categoryId = _Undefined,
    Object? totalSteps = _Undefined,
    Object? stepOrdering = _Undefined,
    Object? intervalDays = _Undefined,
    Object? habitDurationDays = _Undefined,
    Object? habitFrequencyPerWeek = _Undefined,
    Object? habitTotalRequired = _Undefined,
    Object? maxPerformers = _Undefined,
    Object? referenceImages = _Undefined,
    String? verificationCriteria,
    Object? tags = _Undefined,
    Object? expiresAt = _Undefined,
    Object? locationRadius = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      actionType: actionType ?? this.actionType,
      status: status ?? this.status,
      locationId: locationId is int? ? locationId : this.locationId,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      totalSteps: totalSteps is int? ? totalSteps : this.totalSteps,
      stepOrdering: stepOrdering is String? ? stepOrdering : this.stepOrdering,
      intervalDays: intervalDays is int? ? intervalDays : this.intervalDays,
      habitDurationDays: habitDurationDays is int?
          ? habitDurationDays
          : this.habitDurationDays,
      habitFrequencyPerWeek: habitFrequencyPerWeek is int?
          ? habitFrequencyPerWeek
          : this.habitFrequencyPerWeek,
      habitTotalRequired: habitTotalRequired is int?
          ? habitTotalRequired
          : this.habitTotalRequired,
      maxPerformers: maxPerformers is int? ? maxPerformers : this.maxPerformers,
      referenceImages: referenceImages is String?
          ? referenceImages
          : this.referenceImages,
      verificationCriteria: verificationCriteria ?? this.verificationCriteria,
      tags: tags is String? ? tags : this.tags,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      locationRadius: locationRadius is double?
          ? locationRadius
          : this.locationRadius,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
