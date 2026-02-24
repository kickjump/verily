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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class VerificationResult
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = VerificationResultTable();

  static const db = VerificationResultRepository._();

  @override
  int? id;

  int submissionId;

  bool passed;

  double confidenceScore;

  String analysisText;

  String? structuredResult;

  bool spoofingDetected;

  String modelUsed;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static VerificationResultInclude include() {
    return VerificationResultInclude._();
  }

  static VerificationResultIncludeList includeList({
    _i1.WhereExpressionBuilder<VerificationResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationResultTable>? orderByList,
    VerificationResultInclude? include,
  }) {
    return VerificationResultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationResult.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VerificationResult.t),
      include: include,
    );
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

class VerificationResultUpdateTable
    extends _i1.UpdateTable<VerificationResultTable> {
  VerificationResultUpdateTable(super.table);

  _i1.ColumnValue<int, int> submissionId(int value) => _i1.ColumnValue(
    table.submissionId,
    value,
  );

  _i1.ColumnValue<bool, bool> passed(bool value) => _i1.ColumnValue(
    table.passed,
    value,
  );

  _i1.ColumnValue<double, double> confidenceScore(double value) =>
      _i1.ColumnValue(
        table.confidenceScore,
        value,
      );

  _i1.ColumnValue<String, String> analysisText(String value) => _i1.ColumnValue(
    table.analysisText,
    value,
  );

  _i1.ColumnValue<String, String> structuredResult(String? value) =>
      _i1.ColumnValue(
        table.structuredResult,
        value,
      );

  _i1.ColumnValue<bool, bool> spoofingDetected(bool value) => _i1.ColumnValue(
    table.spoofingDetected,
    value,
  );

  _i1.ColumnValue<String, String> modelUsed(String value) => _i1.ColumnValue(
    table.modelUsed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class VerificationResultTable extends _i1.Table<int?> {
  VerificationResultTable({super.tableRelation})
    : super(tableName: 'verification_result') {
    updateTable = VerificationResultUpdateTable(this);
    submissionId = _i1.ColumnInt(
      'submissionId',
      this,
    );
    passed = _i1.ColumnBool(
      'passed',
      this,
    );
    confidenceScore = _i1.ColumnDouble(
      'confidenceScore',
      this,
    );
    analysisText = _i1.ColumnString(
      'analysisText',
      this,
    );
    structuredResult = _i1.ColumnString(
      'structuredResult',
      this,
    );
    spoofingDetected = _i1.ColumnBool(
      'spoofingDetected',
      this,
    );
    modelUsed = _i1.ColumnString(
      'modelUsed',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final VerificationResultUpdateTable updateTable;

  late final _i1.ColumnInt submissionId;

  late final _i1.ColumnBool passed;

  late final _i1.ColumnDouble confidenceScore;

  late final _i1.ColumnString analysisText;

  late final _i1.ColumnString structuredResult;

  late final _i1.ColumnBool spoofingDetected;

  late final _i1.ColumnString modelUsed;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    submissionId,
    passed,
    confidenceScore,
    analysisText,
    structuredResult,
    spoofingDetected,
    modelUsed,
    createdAt,
  ];
}

class VerificationResultInclude extends _i1.IncludeObject {
  VerificationResultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => VerificationResult.t;
}

class VerificationResultIncludeList extends _i1.IncludeList {
  VerificationResultIncludeList._({
    _i1.WhereExpressionBuilder<VerificationResultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VerificationResult.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VerificationResult.t;
}

class VerificationResultRepository {
  const VerificationResultRepository._();

  /// Returns a list of [VerificationResult]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<VerificationResult>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<VerificationResult>(
      where: where?.call(VerificationResult.t),
      orderBy: orderBy?.call(VerificationResult.t),
      orderByList: orderByList?.call(VerificationResult.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [VerificationResult] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<VerificationResult?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationResultTable>? where,
    int? offset,
    _i1.OrderByBuilder<VerificationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<VerificationResult>(
      where: where?.call(VerificationResult.t),
      orderBy: orderBy?.call(VerificationResult.t),
      orderByList: orderByList?.call(VerificationResult.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [VerificationResult] by its [id] or null if no such row exists.
  Future<VerificationResult?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<VerificationResult>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [VerificationResult]s in the list and returns the inserted rows.
  ///
  /// The returned [VerificationResult]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<VerificationResult>> insert(
    _i1.Session session,
    List<VerificationResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<VerificationResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [VerificationResult] and returns the inserted row.
  ///
  /// The returned [VerificationResult] will have its `id` field set.
  Future<VerificationResult> insertRow(
    _i1.Session session,
    VerificationResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VerificationResult>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VerificationResult]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VerificationResult>> update(
    _i1.Session session,
    List<VerificationResult> rows, {
    _i1.ColumnSelections<VerificationResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VerificationResult>(
      rows,
      columns: columns?.call(VerificationResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationResult]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VerificationResult> updateRow(
    _i1.Session session,
    VerificationResult row, {
    _i1.ColumnSelections<VerificationResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VerificationResult>(
      row,
      columns: columns?.call(VerificationResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationResult] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VerificationResult?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<VerificationResultUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VerificationResult>(
      id,
      columnValues: columnValues(VerificationResult.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VerificationResult]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VerificationResult>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<VerificationResultUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<VerificationResultTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationResultTable>? orderBy,
    _i1.OrderByListBuilder<VerificationResultTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VerificationResult>(
      columnValues: columnValues(VerificationResult.t.updateTable),
      where: where(VerificationResult.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationResult.t),
      orderByList: orderByList?.call(VerificationResult.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VerificationResult]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VerificationResult>> delete(
    _i1.Session session,
    List<VerificationResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VerificationResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VerificationResult].
  Future<VerificationResult> deleteRow(
    _i1.Session session,
    VerificationResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VerificationResult>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VerificationResult>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<VerificationResultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VerificationResult>(
      where: where(VerificationResult.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationResultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VerificationResult>(
      where: where?.call(VerificationResult.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
