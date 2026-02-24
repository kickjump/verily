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

abstract class UserFollow
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserFollow._({
    this.id,
    required this.followerId,
    required this.followedId,
    required this.createdAt,
  });

  factory UserFollow({
    int? id,
    required _i1.UuidValue followerId,
    required _i1.UuidValue followedId,
    required DateTime createdAt,
  }) = _UserFollowImpl;

  factory UserFollow.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFollow(
      id: jsonSerialization['id'] as int?,
      followerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['followerId'],
      ),
      followedId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['followedId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = UserFollowTable();

  static const db = UserFollowRepository._();

  @override
  int? id;

  _i1.UuidValue followerId;

  _i1.UuidValue followedId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserFollow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserFollow copyWith({
    int? id,
    _i1.UuidValue? followerId,
    _i1.UuidValue? followedId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserFollow',
      if (id != null) 'id': id,
      'followerId': followerId.toJson(),
      'followedId': followedId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserFollow',
      if (id != null) 'id': id,
      'followerId': followerId.toJson(),
      'followedId': followedId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static UserFollowInclude include() {
    return UserFollowInclude._();
  }

  static UserFollowIncludeList includeList({
    _i1.WhereExpressionBuilder<UserFollowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFollowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFollowTable>? orderByList,
    UserFollowInclude? include,
  }) {
    return UserFollowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFollow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserFollow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFollowImpl extends UserFollow {
  _UserFollowImpl({
    int? id,
    required _i1.UuidValue followerId,
    required _i1.UuidValue followedId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         followerId: followerId,
         followedId: followedId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserFollow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserFollow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? followerId,
    _i1.UuidValue? followedId,
    DateTime? createdAt,
  }) {
    return UserFollow(
      id: id is int? ? id : this.id,
      followerId: followerId ?? this.followerId,
      followedId: followedId ?? this.followedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserFollowUpdateTable extends _i1.UpdateTable<UserFollowTable> {
  UserFollowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> followerId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.followerId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> followedId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.followedId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserFollowTable extends _i1.Table<int?> {
  UserFollowTable({super.tableRelation}) : super(tableName: 'user_follow') {
    updateTable = UserFollowUpdateTable(this);
    followerId = _i1.ColumnUuid(
      'followerId',
      this,
    );
    followedId = _i1.ColumnUuid(
      'followedId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final UserFollowUpdateTable updateTable;

  late final _i1.ColumnUuid followerId;

  late final _i1.ColumnUuid followedId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    followerId,
    followedId,
    createdAt,
  ];
}

class UserFollowInclude extends _i1.IncludeObject {
  UserFollowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserFollow.t;
}

class UserFollowIncludeList extends _i1.IncludeList {
  UserFollowIncludeList._({
    _i1.WhereExpressionBuilder<UserFollowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserFollow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserFollow.t;
}

class UserFollowRepository {
  const UserFollowRepository._();

  /// Returns a list of [UserFollow]s matching the given query parameters.
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
  Future<List<UserFollow>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFollowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFollowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFollowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserFollow>(
      where: where?.call(UserFollow.t),
      orderBy: orderBy?.call(UserFollow.t),
      orderByList: orderByList?.call(UserFollow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserFollow] matching the given query parameters.
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
  Future<UserFollow?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFollowTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserFollowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserFollowTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserFollow>(
      where: where?.call(UserFollow.t),
      orderBy: orderBy?.call(UserFollow.t),
      orderByList: orderByList?.call(UserFollow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserFollow] by its [id] or null if no such row exists.
  Future<UserFollow?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserFollow>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserFollow]s in the list and returns the inserted rows.
  ///
  /// The returned [UserFollow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserFollow>> insert(
    _i1.Session session,
    List<UserFollow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserFollow>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserFollow] and returns the inserted row.
  ///
  /// The returned [UserFollow] will have its `id` field set.
  Future<UserFollow> insertRow(
    _i1.Session session,
    UserFollow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserFollow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserFollow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserFollow>> update(
    _i1.Session session,
    List<UserFollow> rows, {
    _i1.ColumnSelections<UserFollowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserFollow>(
      rows,
      columns: columns?.call(UserFollow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFollow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserFollow> updateRow(
    _i1.Session session,
    UserFollow row, {
    _i1.ColumnSelections<UserFollowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserFollow>(
      row,
      columns: columns?.call(UserFollow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFollow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserFollow?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserFollowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserFollow>(
      id,
      columnValues: columnValues(UserFollow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserFollow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserFollow>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserFollowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserFollowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserFollowTable>? orderBy,
    _i1.OrderByListBuilder<UserFollowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserFollow>(
      columnValues: columnValues(UserFollow.t.updateTable),
      where: where(UserFollow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFollow.t),
      orderByList: orderByList?.call(UserFollow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserFollow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserFollow>> delete(
    _i1.Session session,
    List<UserFollow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserFollow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserFollow].
  Future<UserFollow> deleteRow(
    _i1.Session session,
    UserFollow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserFollow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserFollow>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserFollowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserFollow>(
      where: where(UserFollow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserFollowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserFollow>(
      where: where?.call(UserFollow.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
