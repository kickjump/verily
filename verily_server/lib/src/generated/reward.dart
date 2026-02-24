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

abstract class Reward implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Reward._({
    this.id,
    required this.rewardType,
    required this.name,
    this.description,
    this.iconUrl,
    this.pointValue,
    required this.actionId,
  });

  factory Reward({
    int? id,
    required String rewardType,
    required String name,
    String? description,
    String? iconUrl,
    int? pointValue,
    required int actionId,
  }) = _RewardImpl;

  factory Reward.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reward(
      id: jsonSerialization['id'] as int?,
      rewardType: jsonSerialization['rewardType'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      iconUrl: jsonSerialization['iconUrl'] as String?,
      pointValue: jsonSerialization['pointValue'] as int?,
      actionId: jsonSerialization['actionId'] as int,
    );
  }

  static final t = RewardTable();

  static const db = RewardRepository._();

  @override
  int? id;

  String rewardType;

  String name;

  String? description;

  String? iconUrl;

  int? pointValue;

  int actionId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reward copyWith({
    int? id,
    String? rewardType,
    String? name,
    String? description,
    String? iconUrl,
    int? pointValue,
    int? actionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reward',
      if (id != null) 'id': id,
      'rewardType': rewardType,
      'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (pointValue != null) 'pointValue': pointValue,
      'actionId': actionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reward',
      if (id != null) 'id': id,
      'rewardType': rewardType,
      'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (pointValue != null) 'pointValue': pointValue,
      'actionId': actionId,
    };
  }

  static RewardInclude include() {
    return RewardInclude._();
  }

  static RewardIncludeList includeList({
    _i1.WhereExpressionBuilder<RewardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardTable>? orderByList,
    RewardInclude? include,
  }) {
    return RewardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reward.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Reward.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardImpl extends Reward {
  _RewardImpl({
    int? id,
    required String rewardType,
    required String name,
    String? description,
    String? iconUrl,
    int? pointValue,
    required int actionId,
  }) : super._(
         id: id,
         rewardType: rewardType,
         name: name,
         description: description,
         iconUrl: iconUrl,
         pointValue: pointValue,
         actionId: actionId,
       );

  /// Returns a shallow copy of this [Reward]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reward copyWith({
    Object? id = _Undefined,
    String? rewardType,
    String? name,
    Object? description = _Undefined,
    Object? iconUrl = _Undefined,
    Object? pointValue = _Undefined,
    int? actionId,
  }) {
    return Reward(
      id: id is int? ? id : this.id,
      rewardType: rewardType ?? this.rewardType,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      iconUrl: iconUrl is String? ? iconUrl : this.iconUrl,
      pointValue: pointValue is int? ? pointValue : this.pointValue,
      actionId: actionId ?? this.actionId,
    );
  }
}

class RewardUpdateTable extends _i1.UpdateTable<RewardTable> {
  RewardUpdateTable(super.table);

  _i1.ColumnValue<String, String> rewardType(String value) => _i1.ColumnValue(
    table.rewardType,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> iconUrl(String? value) => _i1.ColumnValue(
    table.iconUrl,
    value,
  );

  _i1.ColumnValue<int, int> pointValue(int? value) => _i1.ColumnValue(
    table.pointValue,
    value,
  );

  _i1.ColumnValue<int, int> actionId(int value) => _i1.ColumnValue(
    table.actionId,
    value,
  );
}

class RewardTable extends _i1.Table<int?> {
  RewardTable({super.tableRelation}) : super(tableName: 'reward') {
    updateTable = RewardUpdateTable(this);
    rewardType = _i1.ColumnString(
      'rewardType',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    iconUrl = _i1.ColumnString(
      'iconUrl',
      this,
    );
    pointValue = _i1.ColumnInt(
      'pointValue',
      this,
    );
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
  }

  late final RewardUpdateTable updateTable;

  late final _i1.ColumnString rewardType;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString iconUrl;

  late final _i1.ColumnInt pointValue;

  late final _i1.ColumnInt actionId;

  @override
  List<_i1.Column> get columns => [
    id,
    rewardType,
    name,
    description,
    iconUrl,
    pointValue,
    actionId,
  ];
}

class RewardInclude extends _i1.IncludeObject {
  RewardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Reward.t;
}

class RewardIncludeList extends _i1.IncludeList {
  RewardIncludeList._({
    _i1.WhereExpressionBuilder<RewardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reward.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Reward.t;
}

class RewardRepository {
  const RewardRepository._();

  /// Returns a list of [Reward]s matching the given query parameters.
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
  Future<List<Reward>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Reward>(
      where: where?.call(Reward.t),
      orderBy: orderBy?.call(Reward.t),
      orderByList: orderByList?.call(Reward.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Reward] matching the given query parameters.
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
  Future<Reward?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardTable>? where,
    int? offset,
    _i1.OrderByBuilder<RewardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RewardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Reward>(
      where: where?.call(Reward.t),
      orderBy: orderBy?.call(Reward.t),
      orderByList: orderByList?.call(Reward.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Reward] by its [id] or null if no such row exists.
  Future<Reward?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Reward>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Reward]s in the list and returns the inserted rows.
  ///
  /// The returned [Reward]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Reward>> insert(
    _i1.Session session,
    List<Reward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Reward>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Reward] and returns the inserted row.
  ///
  /// The returned [Reward] will have its `id` field set.
  Future<Reward> insertRow(
    _i1.Session session,
    Reward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reward>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Reward]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Reward>> update(
    _i1.Session session,
    List<Reward> rows, {
    _i1.ColumnSelections<RewardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Reward>(
      rows,
      columns: columns?.call(Reward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reward]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reward> updateRow(
    _i1.Session session,
    Reward row, {
    _i1.ColumnSelections<RewardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reward>(
      row,
      columns: columns?.call(Reward.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reward] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reward?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RewardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Reward>(
      id,
      columnValues: columnValues(Reward.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reward]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Reward>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RewardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RewardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RewardTable>? orderBy,
    _i1.OrderByListBuilder<RewardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Reward>(
      columnValues: columnValues(Reward.t.updateTable),
      where: where(Reward.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reward.t),
      orderByList: orderByList?.call(Reward.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Reward]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Reward>> delete(
    _i1.Session session,
    List<Reward> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Reward>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Reward].
  Future<Reward> deleteRow(
    _i1.Session session,
    Reward row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reward>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Reward>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RewardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Reward>(
      where: where(Reward.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RewardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Reward>(
      where: where?.call(Reward.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
