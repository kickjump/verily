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

abstract class DeviceAttestation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = DeviceAttestationTable();

  static const db = DeviceAttestationRepository._();

  @override
  int? id;

  int submissionId;

  String platform;

  String attestationType;

  bool verified;

  String? rawResult;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static DeviceAttestationInclude include() {
    return DeviceAttestationInclude._();
  }

  static DeviceAttestationIncludeList includeList({
    _i1.WhereExpressionBuilder<DeviceAttestationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceAttestationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceAttestationTable>? orderByList,
    DeviceAttestationInclude? include,
  }) {
    return DeviceAttestationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceAttestation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeviceAttestation.t),
      include: include,
    );
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

class DeviceAttestationUpdateTable
    extends _i1.UpdateTable<DeviceAttestationTable> {
  DeviceAttestationUpdateTable(super.table);

  _i1.ColumnValue<int, int> submissionId(int value) => _i1.ColumnValue(
    table.submissionId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> attestationType(String value) =>
      _i1.ColumnValue(
        table.attestationType,
        value,
      );

  _i1.ColumnValue<bool, bool> verified(bool value) => _i1.ColumnValue(
    table.verified,
    value,
  );

  _i1.ColumnValue<String, String> rawResult(String? value) => _i1.ColumnValue(
    table.rawResult,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DeviceAttestationTable extends _i1.Table<int?> {
  DeviceAttestationTable({super.tableRelation})
    : super(tableName: 'device_attestation') {
    updateTable = DeviceAttestationUpdateTable(this);
    submissionId = _i1.ColumnInt(
      'submissionId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    attestationType = _i1.ColumnString(
      'attestationType',
      this,
    );
    verified = _i1.ColumnBool(
      'verified',
      this,
    );
    rawResult = _i1.ColumnString(
      'rawResult',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DeviceAttestationUpdateTable updateTable;

  late final _i1.ColumnInt submissionId;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString attestationType;

  late final _i1.ColumnBool verified;

  late final _i1.ColumnString rawResult;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    submissionId,
    platform,
    attestationType,
    verified,
    rawResult,
    createdAt,
  ];
}

class DeviceAttestationInclude extends _i1.IncludeObject {
  DeviceAttestationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeviceAttestation.t;
}

class DeviceAttestationIncludeList extends _i1.IncludeList {
  DeviceAttestationIncludeList._({
    _i1.WhereExpressionBuilder<DeviceAttestationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceAttestation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeviceAttestation.t;
}

class DeviceAttestationRepository {
  const DeviceAttestationRepository._();

  /// Returns a list of [DeviceAttestation]s matching the given query parameters.
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
  Future<List<DeviceAttestation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceAttestationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceAttestationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceAttestationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DeviceAttestation>(
      where: where?.call(DeviceAttestation.t),
      orderBy: orderBy?.call(DeviceAttestation.t),
      orderByList: orderByList?.call(DeviceAttestation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DeviceAttestation] matching the given query parameters.
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
  Future<DeviceAttestation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceAttestationTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeviceAttestationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceAttestationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DeviceAttestation>(
      where: where?.call(DeviceAttestation.t),
      orderBy: orderBy?.call(DeviceAttestation.t),
      orderByList: orderByList?.call(DeviceAttestation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DeviceAttestation] by its [id] or null if no such row exists.
  Future<DeviceAttestation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DeviceAttestation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DeviceAttestation]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceAttestation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DeviceAttestation>> insert(
    _i1.Session session,
    List<DeviceAttestation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DeviceAttestation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DeviceAttestation] and returns the inserted row.
  ///
  /// The returned [DeviceAttestation] will have its `id` field set.
  Future<DeviceAttestation> insertRow(
    _i1.Session session,
    DeviceAttestation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceAttestation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeviceAttestation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeviceAttestation>> update(
    _i1.Session session,
    List<DeviceAttestation> rows, {
    _i1.ColumnSelections<DeviceAttestationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeviceAttestation>(
      rows,
      columns: columns?.call(DeviceAttestation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceAttestation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceAttestation> updateRow(
    _i1.Session session,
    DeviceAttestation row, {
    _i1.ColumnSelections<DeviceAttestationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceAttestation>(
      row,
      columns: columns?.call(DeviceAttestation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceAttestation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceAttestation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<DeviceAttestationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceAttestation>(
      id,
      columnValues: columnValues(DeviceAttestation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceAttestation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeviceAttestation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<DeviceAttestationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeviceAttestationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceAttestationTable>? orderBy,
    _i1.OrderByListBuilder<DeviceAttestationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeviceAttestation>(
      columnValues: columnValues(DeviceAttestation.t.updateTable),
      where: where(DeviceAttestation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceAttestation.t),
      orderByList: orderByList?.call(DeviceAttestation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeviceAttestation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeviceAttestation>> delete(
    _i1.Session session,
    List<DeviceAttestation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeviceAttestation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeviceAttestation].
  Future<DeviceAttestation> deleteRow(
    _i1.Session session,
    DeviceAttestation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceAttestation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeviceAttestation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DeviceAttestationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeviceAttestation>(
      where: where(DeviceAttestation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DeviceAttestationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeviceAttestation>(
      where: where?.call(DeviceAttestation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
