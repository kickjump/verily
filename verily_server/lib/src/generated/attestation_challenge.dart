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

abstract class AttestationChallenge
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = AttestationChallengeTable();

  static const db = AttestationChallengeRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  int actionId;

  String nonce;

  String? visualNonce;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static AttestationChallengeInclude include() {
    return AttestationChallengeInclude._();
  }

  static AttestationChallengeIncludeList includeList({
    _i1.WhereExpressionBuilder<AttestationChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttestationChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttestationChallengeTable>? orderByList,
    AttestationChallengeInclude? include,
  }) {
    return AttestationChallengeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AttestationChallenge.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AttestationChallenge.t),
      include: include,
    );
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

class AttestationChallengeUpdateTable
    extends _i1.UpdateTable<AttestationChallengeTable> {
  AttestationChallengeUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> actionId(int value) => _i1.ColumnValue(
    table.actionId,
    value,
  );

  _i1.ColumnValue<String, String> nonce(String value) => _i1.ColumnValue(
    table.nonce,
    value,
  );

  _i1.ColumnValue<String, String> visualNonce(String? value) => _i1.ColumnValue(
    table.visualNonce,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<bool, bool> used(bool value) => _i1.ColumnValue(
    table.used,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AttestationChallengeTable extends _i1.Table<int?> {
  AttestationChallengeTable({super.tableRelation})
    : super(tableName: 'attestation_challenge') {
    updateTable = AttestationChallengeUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    nonce = _i1.ColumnString(
      'nonce',
      this,
    );
    visualNonce = _i1.ColumnString(
      'visualNonce',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    used = _i1.ColumnBool(
      'used',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AttestationChallengeUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnString nonce;

  late final _i1.ColumnString visualNonce;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnBool used;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    actionId,
    nonce,
    visualNonce,
    expiresAt,
    used,
    createdAt,
  ];
}

class AttestationChallengeInclude extends _i1.IncludeObject {
  AttestationChallengeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AttestationChallenge.t;
}

class AttestationChallengeIncludeList extends _i1.IncludeList {
  AttestationChallengeIncludeList._({
    _i1.WhereExpressionBuilder<AttestationChallengeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AttestationChallenge.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AttestationChallenge.t;
}

class AttestationChallengeRepository {
  const AttestationChallengeRepository._();

  /// Returns a list of [AttestationChallenge]s matching the given query parameters.
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
  Future<List<AttestationChallenge>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttestationChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttestationChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttestationChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AttestationChallenge>(
      where: where?.call(AttestationChallenge.t),
      orderBy: orderBy?.call(AttestationChallenge.t),
      orderByList: orderByList?.call(AttestationChallenge.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AttestationChallenge] matching the given query parameters.
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
  Future<AttestationChallenge?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttestationChallengeTable>? where,
    int? offset,
    _i1.OrderByBuilder<AttestationChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttestationChallengeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AttestationChallenge>(
      where: where?.call(AttestationChallenge.t),
      orderBy: orderBy?.call(AttestationChallenge.t),
      orderByList: orderByList?.call(AttestationChallenge.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AttestationChallenge] by its [id] or null if no such row exists.
  Future<AttestationChallenge?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AttestationChallenge>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AttestationChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [AttestationChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AttestationChallenge>> insert(
    _i1.Session session,
    List<AttestationChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AttestationChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AttestationChallenge] and returns the inserted row.
  ///
  /// The returned [AttestationChallenge] will have its `id` field set.
  Future<AttestationChallenge> insertRow(
    _i1.Session session,
    AttestationChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AttestationChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AttestationChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AttestationChallenge>> update(
    _i1.Session session,
    List<AttestationChallenge> rows, {
    _i1.ColumnSelections<AttestationChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AttestationChallenge>(
      rows,
      columns: columns?.call(AttestationChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AttestationChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AttestationChallenge> updateRow(
    _i1.Session session,
    AttestationChallenge row, {
    _i1.ColumnSelections<AttestationChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AttestationChallenge>(
      row,
      columns: columns?.call(AttestationChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AttestationChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AttestationChallenge?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AttestationChallengeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AttestationChallenge>(
      id,
      columnValues: columnValues(AttestationChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AttestationChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AttestationChallenge>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AttestationChallengeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AttestationChallengeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttestationChallengeTable>? orderBy,
    _i1.OrderByListBuilder<AttestationChallengeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AttestationChallenge>(
      columnValues: columnValues(AttestationChallenge.t.updateTable),
      where: where(AttestationChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AttestationChallenge.t),
      orderByList: orderByList?.call(AttestationChallenge.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AttestationChallenge]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AttestationChallenge>> delete(
    _i1.Session session,
    List<AttestationChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AttestationChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AttestationChallenge].
  Future<AttestationChallenge> deleteRow(
    _i1.Session session,
    AttestationChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AttestationChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AttestationChallenge>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AttestationChallengeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AttestationChallenge>(
      where: where(AttestationChallenge.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttestationChallengeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AttestationChallenge>(
      where: where?.call(AttestationChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
