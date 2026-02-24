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

abstract class RewardPool
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RewardPool._({
    this.id,
    required this.actionId,
    required this.creatorId,
    required this.rewardType,
    this.tokenMintAddress,
    required this.totalAmount,
    required this.remainingAmount,
    required this.perPersonAmount,
    this.maxRecipients,
    this.expiresAt,
    required this.platformFeePercent,
    required this.status,
    this.fundingTxSignature,
    required this.createdAt,
  });

  factory RewardPool({
    int? id,
    required int actionId,
    required _i1.UuidValue creatorId,
    required String rewardType,
    String? tokenMintAddress,
    required double totalAmount,
    required double remainingAmount,
    required double perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    required double platformFeePercent,
    required String status,
    String? fundingTxSignature,
    required DateTime createdAt,
  }) = _RewardPoolImpl;

  factory RewardPool.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardPool(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      creatorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      rewardType: jsonSerialization['rewardType'] as String,
      tokenMintAddress: jsonSerialization['tokenMintAddress'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      remainingAmount: (jsonSerialization['remainingAmount'] as num).toDouble(),
      perPersonAmount: (jsonSerialization['perPersonAmount'] as num).toDouble(),
      maxRecipients: jsonSerialization['maxRecipients'] as int?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      platformFeePercent: (jsonSerialization['platformFeePercent'] as num)
          .toDouble(),
      status: jsonSerialization['status'] as String,
      fundingTxSignature: jsonSerialization['fundingTxSignature'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RewardPoolTable();

  static const db = RewardPoolRepository._();

  @override
  int? id;

  int actionId;

  _i1.UuidValue creatorId;

  String rewardType;

  String? tokenMintAddress;

  double totalAmount;

  double remainingAmount;

  double perPersonAmount;

  int? maxRecipients;

  DateTime? expiresAt;

  double platformFeePercent;

  String status;

  String? fundingTxSignature;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RewardPool]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RewardPool copyWith({
    int? id,
    int? actionId,
    _i1.UuidValue? creatorId,
    String? rewardType,
    String? tokenMintAddress,
    double? totalAmount,
    double? remainingAmount,
    double? perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    double? platformFeePercent,
    String? status,
    String? fundingTxSignature,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardPool',
      if (id != null) 'id': id,
      'actionId': actionId,
      'creatorId': creatorId.toJson(),
      'rewardType': rewardType,
      if (tokenMintAddress != null) 'tokenMintAddress': tokenMintAddress,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'perPersonAmount': perPersonAmount,
      if (maxRecipients != null) 'maxRecipients': maxRecipients,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'platformFeePercent': platformFeePercent,
      'status': status,
      if (fundingTxSignature != null) 'fundingTxSignature': fundingTxSignature,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardPool',
      if (id != null) 'id': id,
      'actionId': actionId,
      'creatorId': creatorId.toJson(),
      'rewardType': rewardType,
      if (tokenMintAddress != null) 'tokenMintAddress': tokenMintAddress,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'perPersonAmount': perPersonAmount,
      if (maxRecipients != null) 'maxRecipients': maxRecipients,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'platformFeePercent': platformFeePercent,
      'status': status,
      if (fundingTxSignature != null) 'fundingTxSignature': fundingTxSignature,
      'createdAt': createdAt.toJson(),
    };
  }

  static RewardPoolInclude include() {
    return RewardPoolInclude._();
  }

  static RewardPoolIncludeList includeList({
    _i1.WhereExpressionBuilder<RewardPoolTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardPoolTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardPoolTable>? orderByList,
    RewardPoolInclude? include,
  }) {
    return RewardPoolIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardPool.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RewardPool.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardPoolImpl extends RewardPool {
  _RewardPoolImpl({
    int? id,
    required int actionId,
    required _i1.UuidValue creatorId,
    required String rewardType,
    String? tokenMintAddress,
    required double totalAmount,
    required double remainingAmount,
    required double perPersonAmount,
    int? maxRecipients,
    DateTime? expiresAt,
    required double platformFeePercent,
    required String status,
    String? fundingTxSignature,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actionId: actionId,
         creatorId: creatorId,
         rewardType: rewardType,
         tokenMintAddress: tokenMintAddress,
         totalAmount: totalAmount,
         remainingAmount: remainingAmount,
         perPersonAmount: perPersonAmount,
         maxRecipients: maxRecipients,
         expiresAt: expiresAt,
         platformFeePercent: platformFeePercent,
         status: status,
         fundingTxSignature: fundingTxSignature,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RewardPool]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RewardPool copyWith({
    Object? id = _Undefined,
    int? actionId,
    _i1.UuidValue? creatorId,
    String? rewardType,
    Object? tokenMintAddress = _Undefined,
    double? totalAmount,
    double? remainingAmount,
    double? perPersonAmount,
    Object? maxRecipients = _Undefined,
    Object? expiresAt = _Undefined,
    double? platformFeePercent,
    String? status,
    Object? fundingTxSignature = _Undefined,
    DateTime? createdAt,
  }) {
    return RewardPool(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      creatorId: creatorId ?? this.creatorId,
      rewardType: rewardType ?? this.rewardType,
      tokenMintAddress: tokenMintAddress is String?
          ? tokenMintAddress
          : this.tokenMintAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      perPersonAmount: perPersonAmount ?? this.perPersonAmount,
      maxRecipients: maxRecipients is int? ? maxRecipients : this.maxRecipients,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      platformFeePercent: platformFeePercent ?? this.platformFeePercent,
      status: status ?? this.status,
      fundingTxSignature: fundingTxSignature is String?
          ? fundingTxSignature
          : this.fundingTxSignature,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RewardPoolUpdateTable extends _i1.UpdateTable<RewardPoolTable> {
  RewardPoolUpdateTable(super.table);

  _i1.ColumnValue<int, int> actionId(int value) => _i1.ColumnValue(
    table.actionId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> creatorId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.creatorId,
    value,
  );

  _i1.ColumnValue<String, String> rewardType(String value) => _i1.ColumnValue(
    table.rewardType,
    value,
  );

  _i1.ColumnValue<String, String> tokenMintAddress(String? value) =>
      _i1.ColumnValue(
        table.tokenMintAddress,
        value,
      );

  _i1.ColumnValue<double, double> totalAmount(double value) => _i1.ColumnValue(
    table.totalAmount,
    value,
  );

  _i1.ColumnValue<double, double> remainingAmount(double value) =>
      _i1.ColumnValue(
        table.remainingAmount,
        value,
      );

  _i1.ColumnValue<double, double> perPersonAmount(double value) =>
      _i1.ColumnValue(
        table.perPersonAmount,
        value,
      );

  _i1.ColumnValue<int, int> maxRecipients(int? value) => _i1.ColumnValue(
    table.maxRecipients,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<double, double> platformFeePercent(double value) =>
      _i1.ColumnValue(
        table.platformFeePercent,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> fundingTxSignature(String? value) =>
      _i1.ColumnValue(
        table.fundingTxSignature,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RewardPoolTable extends _i1.Table<int?> {
  RewardPoolTable({super.tableRelation}) : super(tableName: 'reward_pool') {
    updateTable = RewardPoolUpdateTable(this);
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    creatorId = _i1.ColumnUuid(
      'creatorId',
      this,
    );
    rewardType = _i1.ColumnString(
      'rewardType',
      this,
    );
    tokenMintAddress = _i1.ColumnString(
      'tokenMintAddress',
      this,
    );
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
      this,
    );
    remainingAmount = _i1.ColumnDouble(
      'remainingAmount',
      this,
    );
    perPersonAmount = _i1.ColumnDouble(
      'perPersonAmount',
      this,
    );
    maxRecipients = _i1.ColumnInt(
      'maxRecipients',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    platformFeePercent = _i1.ColumnDouble(
      'platformFeePercent',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    fundingTxSignature = _i1.ColumnString(
      'fundingTxSignature',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RewardPoolUpdateTable updateTable;

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnUuid creatorId;

  late final _i1.ColumnString rewardType;

  late final _i1.ColumnString tokenMintAddress;

  late final _i1.ColumnDouble totalAmount;

  late final _i1.ColumnDouble remainingAmount;

  late final _i1.ColumnDouble perPersonAmount;

  late final _i1.ColumnInt maxRecipients;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDouble platformFeePercent;

  late final _i1.ColumnString status;

  late final _i1.ColumnString fundingTxSignature;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    actionId,
    creatorId,
    rewardType,
    tokenMintAddress,
    totalAmount,
    remainingAmount,
    perPersonAmount,
    maxRecipients,
    expiresAt,
    platformFeePercent,
    status,
    fundingTxSignature,
    createdAt,
  ];
}

class RewardPoolInclude extends _i1.IncludeObject {
  RewardPoolInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RewardPool.t;
}

class RewardPoolIncludeList extends _i1.IncludeList {
  RewardPoolIncludeList._({
    _i1.WhereExpressionBuilder<RewardPoolTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RewardPool.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RewardPool.t;
}

class RewardPoolRepository {
  const RewardPoolRepository._();

  /// Returns a list of [RewardPool]s matching the given query parameters.
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
  Future<List<RewardPool>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardPoolTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardPoolTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardPoolTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RewardPool>(
      where: where?.call(RewardPool.t),
      orderBy: orderBy?.call(RewardPool.t),
      orderByList: orderByList?.call(RewardPool.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [RewardPool] matching the given query parameters.
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
  Future<RewardPool?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardPoolTable>? where,
    int? offset,
    _i1.OrderByBuilder<RewardPoolTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardPoolTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RewardPool>(
      where: where?.call(RewardPool.t),
      orderBy: orderBy?.call(RewardPool.t),
      orderByList: orderByList?.call(RewardPool.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [RewardPool] by its [id] or null if no such row exists.
  Future<RewardPool?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RewardPool>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [RewardPool]s in the list and returns the inserted rows.
  ///
  /// The returned [RewardPool]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RewardPool>> insert(
    _i1.Session session,
    List<RewardPool> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RewardPool>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RewardPool] and returns the inserted row.
  ///
  /// The returned [RewardPool] will have its `id` field set.
  Future<RewardPool> insertRow(
    _i1.Session session,
    RewardPool row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RewardPool>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RewardPool]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RewardPool>> update(
    _i1.Session session,
    List<RewardPool> rows, {
    _i1.ColumnSelections<RewardPoolTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RewardPool>(
      rows,
      columns: columns?.call(RewardPool.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardPool]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RewardPool> updateRow(
    _i1.Session session,
    RewardPool row, {
    _i1.ColumnSelections<RewardPoolTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RewardPool>(
      row,
      columns: columns?.call(RewardPool.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardPool] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RewardPool?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RewardPoolUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RewardPool>(
      id,
      columnValues: columnValues(RewardPool.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RewardPool]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RewardPool>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RewardPoolUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RewardPoolTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardPoolTable>? orderBy,
    _i1.OrderByListBuilder<RewardPoolTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RewardPool>(
      columnValues: columnValues(RewardPool.t.updateTable),
      where: where(RewardPool.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardPool.t),
      orderByList: orderByList?.call(RewardPool.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RewardPool]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RewardPool>> delete(
    _i1.Session session,
    List<RewardPool> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RewardPool>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RewardPool].
  Future<RewardPool> deleteRow(
    _i1.Session session,
    RewardPool row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RewardPool>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RewardPool>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RewardPoolTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RewardPool>(
      where: where(RewardPool.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardPoolTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RewardPool>(
      where: where?.call(RewardPool.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
