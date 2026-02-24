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

abstract class RewardDistribution
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RewardDistribution._({
    this.id,
    required this.rewardPoolId,
    required this.recipientId,
    required this.submissionId,
    required this.amount,
    this.txSignature,
    required this.status,
    required this.createdAt,
  });

  factory RewardDistribution({
    int? id,
    required int rewardPoolId,
    required _i1.UuidValue recipientId,
    required int submissionId,
    required double amount,
    String? txSignature,
    required String status,
    required DateTime createdAt,
  }) = _RewardDistributionImpl;

  factory RewardDistribution.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardDistribution(
      id: jsonSerialization['id'] as int?,
      rewardPoolId: jsonSerialization['rewardPoolId'] as int,
      recipientId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['recipientId'],
      ),
      submissionId: jsonSerialization['submissionId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      txSignature: jsonSerialization['txSignature'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RewardDistributionTable();

  static const db = RewardDistributionRepository._();

  @override
  int? id;

  int rewardPoolId;

  _i1.UuidValue recipientId;

  int submissionId;

  double amount;

  String? txSignature;

  String status;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RewardDistribution]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RewardDistribution copyWith({
    int? id,
    int? rewardPoolId,
    _i1.UuidValue? recipientId,
    int? submissionId,
    double? amount,
    String? txSignature,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardDistribution',
      if (id != null) 'id': id,
      'rewardPoolId': rewardPoolId,
      'recipientId': recipientId.toJson(),
      'submissionId': submissionId,
      'amount': amount,
      if (txSignature != null) 'txSignature': txSignature,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardDistribution',
      if (id != null) 'id': id,
      'rewardPoolId': rewardPoolId,
      'recipientId': recipientId.toJson(),
      'submissionId': submissionId,
      'amount': amount,
      if (txSignature != null) 'txSignature': txSignature,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static RewardDistributionInclude include() {
    return RewardDistributionInclude._();
  }

  static RewardDistributionIncludeList includeList({
    _i1.WhereExpressionBuilder<RewardDistributionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardDistributionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardDistributionTable>? orderByList,
    RewardDistributionInclude? include,
  }) {
    return RewardDistributionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardDistribution.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RewardDistribution.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardDistributionImpl extends RewardDistribution {
  _RewardDistributionImpl({
    int? id,
    required int rewardPoolId,
    required _i1.UuidValue recipientId,
    required int submissionId,
    required double amount,
    String? txSignature,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         rewardPoolId: rewardPoolId,
         recipientId: recipientId,
         submissionId: submissionId,
         amount: amount,
         txSignature: txSignature,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RewardDistribution]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RewardDistribution copyWith({
    Object? id = _Undefined,
    int? rewardPoolId,
    _i1.UuidValue? recipientId,
    int? submissionId,
    double? amount,
    Object? txSignature = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return RewardDistribution(
      id: id is int? ? id : this.id,
      rewardPoolId: rewardPoolId ?? this.rewardPoolId,
      recipientId: recipientId ?? this.recipientId,
      submissionId: submissionId ?? this.submissionId,
      amount: amount ?? this.amount,
      txSignature: txSignature is String? ? txSignature : this.txSignature,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RewardDistributionUpdateTable
    extends _i1.UpdateTable<RewardDistributionTable> {
  RewardDistributionUpdateTable(super.table);

  _i1.ColumnValue<int, int> rewardPoolId(int value) => _i1.ColumnValue(
    table.rewardPoolId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> recipientId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.recipientId,
    value,
  );

  _i1.ColumnValue<int, int> submissionId(int value) => _i1.ColumnValue(
    table.submissionId,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> txSignature(String? value) => _i1.ColumnValue(
    table.txSignature,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RewardDistributionTable extends _i1.Table<int?> {
  RewardDistributionTable({super.tableRelation})
    : super(tableName: 'reward_distribution') {
    updateTable = RewardDistributionUpdateTable(this);
    rewardPoolId = _i1.ColumnInt(
      'rewardPoolId',
      this,
    );
    recipientId = _i1.ColumnUuid(
      'recipientId',
      this,
    );
    submissionId = _i1.ColumnInt(
      'submissionId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    txSignature = _i1.ColumnString(
      'txSignature',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RewardDistributionUpdateTable updateTable;

  late final _i1.ColumnInt rewardPoolId;

  late final _i1.ColumnUuid recipientId;

  late final _i1.ColumnInt submissionId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString txSignature;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    rewardPoolId,
    recipientId,
    submissionId,
    amount,
    txSignature,
    status,
    createdAt,
  ];
}

class RewardDistributionInclude extends _i1.IncludeObject {
  RewardDistributionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RewardDistribution.t;
}

class RewardDistributionIncludeList extends _i1.IncludeList {
  RewardDistributionIncludeList._({
    _i1.WhereExpressionBuilder<RewardDistributionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RewardDistribution.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RewardDistribution.t;
}

class RewardDistributionRepository {
  const RewardDistributionRepository._();

  /// Returns a list of [RewardDistribution]s matching the given query parameters.
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
  Future<List<RewardDistribution>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardDistributionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardDistributionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardDistributionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RewardDistribution>(
      where: where?.call(RewardDistribution.t),
      orderBy: orderBy?.call(RewardDistribution.t),
      orderByList: orderByList?.call(RewardDistribution.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [RewardDistribution] matching the given query parameters.
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
  Future<RewardDistribution?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardDistributionTable>? where,
    int? offset,
    _i1.OrderByBuilder<RewardDistributionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardDistributionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RewardDistribution>(
      where: where?.call(RewardDistribution.t),
      orderBy: orderBy?.call(RewardDistribution.t),
      orderByList: orderByList?.call(RewardDistribution.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [RewardDistribution] by its [id] or null if no such row exists.
  Future<RewardDistribution?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RewardDistribution>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [RewardDistribution]s in the list and returns the inserted rows.
  ///
  /// The returned [RewardDistribution]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RewardDistribution>> insert(
    _i1.Session session,
    List<RewardDistribution> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RewardDistribution>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RewardDistribution] and returns the inserted row.
  ///
  /// The returned [RewardDistribution] will have its `id` field set.
  Future<RewardDistribution> insertRow(
    _i1.Session session,
    RewardDistribution row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RewardDistribution>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RewardDistribution]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RewardDistribution>> update(
    _i1.Session session,
    List<RewardDistribution> rows, {
    _i1.ColumnSelections<RewardDistributionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RewardDistribution>(
      rows,
      columns: columns?.call(RewardDistribution.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardDistribution]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RewardDistribution> updateRow(
    _i1.Session session,
    RewardDistribution row, {
    _i1.ColumnSelections<RewardDistributionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RewardDistribution>(
      row,
      columns: columns?.call(RewardDistribution.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardDistribution] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RewardDistribution?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RewardDistributionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RewardDistribution>(
      id,
      columnValues: columnValues(RewardDistribution.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RewardDistribution]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RewardDistribution>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RewardDistributionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RewardDistributionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardDistributionTable>? orderBy,
    _i1.OrderByListBuilder<RewardDistributionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RewardDistribution>(
      columnValues: columnValues(RewardDistribution.t.updateTable),
      where: where(RewardDistribution.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardDistribution.t),
      orderByList: orderByList?.call(RewardDistribution.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RewardDistribution]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RewardDistribution>> delete(
    _i1.Session session,
    List<RewardDistribution> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RewardDistribution>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RewardDistribution].
  Future<RewardDistribution> deleteRow(
    _i1.Session session,
    RewardDistribution row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RewardDistribution>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RewardDistribution>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RewardDistributionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RewardDistribution>(
      where: where(RewardDistribution.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardDistributionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RewardDistribution>(
      where: where?.call(RewardDistribution.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
