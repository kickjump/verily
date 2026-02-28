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

abstract class ActionStep implements _i1.SerializableModel {
  ActionStep._({
    this.id,
    required this.actionId,
    required this.stepNumber,
    required this.title,
    this.description,
    required this.verificationCriteria,
    this.locationId,
    required this.isOptional,
  });

  factory ActionStep({
    int? id,
    required int actionId,
    required int stepNumber,
    required String title,
    String? description,
    required String verificationCriteria,
    int? locationId,
    required bool isOptional,
  }) = _ActionStepImpl;

  factory ActionStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionStep(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      stepNumber: jsonSerialization['stepNumber'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      verificationCriteria: jsonSerialization['verificationCriteria'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      isOptional: jsonSerialization['isOptional'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int actionId;

  int stepNumber;

  String title;

  String? description;

  String verificationCriteria;

  int? locationId;

  bool isOptional;

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionStep copyWith({
    int? id,
    int? actionId,
    int? stepNumber,
    String? title,
    String? description,
    String? verificationCriteria,
    int? locationId,
    bool? isOptional,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionStep',
      if (id != null) 'id': id,
      'actionId': actionId,
      'stepNumber': stepNumber,
      'title': title,
      if (description != null) 'description': description,
      'verificationCriteria': verificationCriteria,
      if (locationId != null) 'locationId': locationId,
      'isOptional': isOptional,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionStepImpl extends ActionStep {
  _ActionStepImpl({
    int? id,
    required int actionId,
    required int stepNumber,
    required String title,
    String? description,
    required String verificationCriteria,
    int? locationId,
    required bool isOptional,
  }) : super._(
         id: id,
         actionId: actionId,
         stepNumber: stepNumber,
         title: title,
         description: description,
         verificationCriteria: verificationCriteria,
         locationId: locationId,
         isOptional: isOptional,
       );

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionStep copyWith({
    Object? id = _Undefined,
    int? actionId,
    int? stepNumber,
    String? title,
    Object? description = _Undefined,
    String? verificationCriteria,
    Object? locationId = _Undefined,
    bool? isOptional,
  }) {
    return ActionStep(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      verificationCriteria: verificationCriteria ?? this.verificationCriteria,
      locationId: locationId is int? ? locationId : this.locationId,
      isOptional: isOptional ?? this.isOptional,
    );
  }
}
