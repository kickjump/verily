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

abstract class UserReward
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserReward._({
    this.id,
    required this.userId,
    required this.rewardId,
    this.submissionId,
    required this.earnedAt,
  });

  factory UserReward({
    int? id,
    required _i1.UuidValue userId,
    required int rewardId,
    int? submissionId,
    required DateTime earnedAt,
  }) = _UserRewardImpl;

  factory UserReward.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserReward(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      rewardId: jsonSerialization['rewardId'] as int,
      submissionId: jsonSerialization['submissionId'] as int?,
      earnedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['earnedAt'],
      ),
    );
  }

  static final t = UserRewardTable();

  static const db = UserRewardRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  int rewardId;

  int? submissionId;

  DateTime earnedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserReward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserReward copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? rewardId,
    int? submissionId,
    DateTime? earnedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserReward',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'rewardId': rewardId,
      if (submissionId != null) 'submissionId': submissionId,
      'earnedAt': earnedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserReward',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'rewardId': rewardId,
      if (submissionId != null) 'submissionId': submissionId,
      'earnedAt': earnedAt.toJson(),
    };
  }

  static UserRewardInclude include() {
    return UserRewardInclude._();
  }

  static UserRewardIncludeList includeList({
    _i1.WhereExpressionBuilder<UserRewardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRewardTable>? orderByList,
    UserRewardInclude? include,
  }) {
    return UserRewardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserReward.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserReward.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRewardImpl extends UserReward {
  _UserRewardImpl({
    int? id,
    required _i1.UuidValue userId,
    required int rewardId,
    int? submissionId,
    required DateTime earnedAt,
  }) : super._(
         id: id,
         userId: userId,
         rewardId: rewardId,
         submissionId: submissionId,
         earnedAt: earnedAt,
       );

  /// Returns a shallow copy of this [UserReward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserReward copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? rewardId,
    Object? submissionId = _Undefined,
    DateTime? earnedAt,
  }) {
    return UserReward(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      rewardId: rewardId ?? this.rewardId,
      submissionId: submissionId is int? ? submissionId : this.submissionId,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}

class UserRewardUpdateTable extends _i1.UpdateTable<UserRewardTable> {
  UserRewardUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> rewardId(int value) => _i1.ColumnValue(
    table.rewardId,
    value,
  );

  _i1.ColumnValue<int, int> submissionId(int? value) => _i1.ColumnValue(
    table.submissionId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> earnedAt(DateTime value) =>
      _i1.ColumnValue(
        table.earnedAt,
        value,
      );
}

class UserRewardTable extends _i1.Table<int?> {
  UserRewardTable({super.tableRelation}) : super(tableName: 'user_reward') {
    updateTable = UserRewardUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    rewardId = _i1.ColumnInt(
      'rewardId',
      this,
    );
    submissionId = _i1.ColumnInt(
      'submissionId',
      this,
    );
    earnedAt = _i1.ColumnDateTime(
      'earnedAt',
      this,
    );
  }

  late final UserRewardUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnInt rewardId;

  late final _i1.ColumnInt submissionId;

  late final _i1.ColumnDateTime earnedAt;

  @override
  List<_i1.Column<dynamic>> get columns => [
    id,
    userId,
    rewardId,
    submissionId,
    earnedAt,
  ];
}

class UserRewardInclude extends _i1.IncludeObject {
  UserRewardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserReward.t;
}

class UserRewardIncludeList extends _i1.IncludeList {
  UserRewardIncludeList._({
    _i1.WhereExpressionBuilder<UserRewardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserReward.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserReward.t;
}

class UserRewardRepository {
  const UserRewardRepository._();

  /// Returns a list of [UserReward]s matching the given query parameters.
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
  Future<List<UserReward>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRewardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRewardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserReward>(
      where: where?.call(UserReward.t),
      orderBy: orderBy?.call(UserReward.t),
      orderByList: orderByList?.call(UserReward.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserReward] matching the given query parameters.
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
  Future<UserReward?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRewardTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserRewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRewardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserReward>(
      where: where?.call(UserReward.t),
      orderBy: orderBy?.call(UserReward.t),
      orderByList: orderByList?.call(UserReward.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserReward] by its [id] or null if no such row exists.
  Future<UserReward?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserReward>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserReward]s in the list and returns the inserted rows.
  ///
  /// The returned [UserReward]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserReward>> insert(
    _i1.Session session,
    List<UserReward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserReward>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserReward] and returns the inserted row.
  ///
  /// The returned [UserReward] will have its `id` field set.
  Future<UserReward> insertRow(
    _i1.Session session,
    UserReward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserReward>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserReward]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserReward>> update(
    _i1.Session session,
    List<UserReward> rows, {
    _i1.ColumnSelections<UserRewardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserReward>(
      rows,
      columns: columns?.call(UserReward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserReward]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserReward> updateRow(
    _i1.Session session,
    UserReward row, {
    _i1.ColumnSelections<UserRewardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserReward>(
      row,
      columns: columns?.call(UserReward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserReward] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserReward?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserRewardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserReward>(
      id,
      columnValues: columnValues(UserReward.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserReward]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserReward>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserRewardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserRewardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRewardTable>? orderBy,
    _i1.OrderByListBuilder<UserRewardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserReward>(
      columnValues: columnValues(UserReward.t.updateTable),
      where: where(UserReward.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserReward.t),
      orderByList: orderByList?.call(UserReward.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserReward]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserReward>> delete(
    _i1.Session session,
    List<UserReward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserReward>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserReward].
  Future<UserReward> deleteRow(
    _i1.Session session,
    UserReward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserReward>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserReward>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserRewardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserReward>(
      where: where(UserReward.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRewardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserReward>(
      where: where?.call(UserReward.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
