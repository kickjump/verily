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

abstract class VerificationResult implements _i1.SerializableModel {
  VerificationResult._({
    this.id,
    required this.submissionId,
    required this.passed,
    required this.confidenceScore,
    required this.analysisText,
    this.structuredResult,
    required this.spoofingDetected,
    required this.modelUsed,
    required this.createdAt,
  });

  factory VerificationResult({
    int? id,
    required int submissionId,
    required bool passed,
    required double confidenceScore,
    required String analysisText,
    String? structuredResult,
    required bool spoofingDetected,
    required String modelUsed,
    required DateTime createdAt,
  }) = _VerificationResultImpl;

  factory VerificationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationResult(
      id: jsonSerialization['id'] as int?,
      submissionId: jsonSerialization['submissionId'] as int,
      passed: jsonSerialization['passed'] as bool,
      confidenceScore: (jsonSerialization['confidenceScore'] as num).toDouble(),
      analysisText: jsonSerialization['analysisText'] as String,
      structuredResult: jsonSerialization['structuredResult'] as String?,
      spoofingDetected: jsonSerialization['spoofingDetected'] as bool,
      modelUsed: jsonSerialization['modelUsed'] as String,
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

  bool passed;

  double confidenceScore;

  String analysisText;

  String? structuredResult;

  bool spoofingDetected;

  String modelUsed;

  DateTime createdAt;

  /// Returns a shallow copy of this [VerificationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationResult copyWith({
    int? id,
    int? submissionId,
    bool? passed,
    double? confidenceScore,
    String? analysisText,
    String? structuredResult,
    bool? spoofingDetected,
    String? modelUsed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationResult',
      if (id != null) 'id': id,
      'submissionId': submissionId,
      'passed': passed,
      'confidenceScore': confidenceScore,
      'analysisText': analysisText,
      if (structuredResult != null) 'structuredResult': structuredResult,
      'spoofingDetected': spoofingDetected,
      'modelUsed': modelUsed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationResultImpl extends VerificationResult {
  _VerificationResultImpl({
    int? id,
    required int submissionId,
    required bool passed,
    required double confidenceScore,
    required String analysisText,
    String? structuredResult,
    required bool spoofingDetected,
    required String modelUsed,
    required DateTime createdAt,
  }) : super._(
         id: id,
         submissionId: submissionId,
         passed: passed,
         confidenceScore: confidenceScore,
         analysisText: analysisText,
         structuredResult: structuredResult,
         spoofingDetected: spoofingDetected,
         modelUsed: modelUsed,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VerificationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationResult copyWith({
    Object? id = _Undefined,
    int? submissionId,
    bool? passed,
    double? confidenceScore,
    String? analysisText,
    Object? structuredResult = _Undefined,
    bool? spoofingDetected,
    String? modelUsed,
    DateTime? createdAt,
  }) {
    return VerificationResult(
      id: id is int? ? id : this.id,
      submissionId: submissionId ?? this.submissionId,
      passed: passed ?? this.passed,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      analysisText: analysisText ?? this.analysisText,
      structuredResult: structuredResult is String?
          ? structuredResult
          : this.structuredResult,
      spoofingDetected: spoofingDetected ?? this.spoofingDetected,
      modelUsed: modelUsed ?? this.modelUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
