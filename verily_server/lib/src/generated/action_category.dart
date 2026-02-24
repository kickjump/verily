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

abstract class ActionCategory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ActionCategory._({
    this.id,
    required this.name,
    this.description,
    this.iconName,
    required this.sortOrder,
  });

  factory ActionCategory({
    int? id,
    required String name,
    String? description,
    String? iconName,
    required int sortOrder,
  }) = _ActionCategoryImpl;

  factory ActionCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionCategory(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      iconName: jsonSerialization['iconName'] as String?,
      sortOrder: jsonSerialization['sortOrder'] as int,
    );
  }

  static final t = ActionCategoryTable();

  static const db = ActionCategoryRepository._();

  @override
  int? id;

  String name;

  String? description;

  String? iconName;

  int sortOrder;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActionCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionCategory copyWith({
    int? id,
    String? name,
    String? description,
    String? iconName,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionCategory',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (iconName != null) 'iconName': iconName,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActionCategory',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (iconName != null) 'iconName': iconName,
      'sortOrder': sortOrder,
    };
  }

  static ActionCategoryInclude include() {
    return ActionCategoryInclude._();
  }

  static ActionCategoryIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionCategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionCategoryTable>? orderByList,
    ActionCategoryInclude? include,
  }) {
    return ActionCategoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionCategory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActionCategory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionCategoryImpl extends ActionCategory {
  _ActionCategoryImpl({
    int? id,
    required String name,
    String? description,
    String? iconName,
    required int sortOrder,
  }) : super._(
         id: id,
         name: name,
         description: description,
         iconName: iconName,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [ActionCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionCategory copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? iconName = _Undefined,
    int? sortOrder,
  }) {
    return ActionCategory(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      iconName: iconName is String? ? iconName : this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ActionCategoryUpdateTable extends _i1.UpdateTable<ActionCategoryTable> {
  ActionCategoryUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> iconName(String? value) => _i1.ColumnValue(
    table.iconName,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
    value,
  );
}

class ActionCategoryTable extends _i1.Table<int?> {
  ActionCategoryTable({super.tableRelation})
    : super(tableName: 'action_category') {
    updateTable = ActionCategoryUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    iconName = _i1.ColumnString(
      'iconName',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
      this,
    );
  }

  late final ActionCategoryUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString iconName;

  late final _i1.ColumnInt sortOrder;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    iconName,
    sortOrder,
  ];
}

class ActionCategoryInclude extends _i1.IncludeObject {
  ActionCategoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ActionCategory.t;
}

class ActionCategoryIncludeList extends _i1.IncludeList {
  ActionCategoryIncludeList._({
    _i1.WhereExpressionBuilder<ActionCategoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActionCategory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ActionCategory.t;
}

class ActionCategoryRepository {
  const ActionCategoryRepository._();

  /// Returns a list of [ActionCategory]s matching the given query parameters.
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
  Future<List<ActionCategory>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionCategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionCategoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ActionCategory>(
      where: where?.call(ActionCategory.t),
      orderBy: orderBy?.call(ActionCategory.t),
      orderByList: orderByList?.call(ActionCategory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ActionCategory] matching the given query parameters.
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
  Future<ActionCategory?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionCategoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionCategoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ActionCategory>(
      where: where?.call(ActionCategory.t),
      orderBy: orderBy?.call(ActionCategory.t),
      orderByList: orderByList?.call(ActionCategory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ActionCategory] by its [id] or null if no such row exists.
  Future<ActionCategory?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ActionCategory>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ActionCategory]s in the list and returns the inserted rows.
  ///
  /// The returned [ActionCategory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActionCategory>> insert(
    _i1.Session session,
    List<ActionCategory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActionCategory>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ActionCategory] and returns the inserted row.
  ///
  /// The returned [ActionCategory] will have its `id` field set.
  Future<ActionCategory> insertRow(
    _i1.Session session,
    ActionCategory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActionCategory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ActionCategory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActionCategory>> update(
    _i1.Session session,
    List<ActionCategory> rows, {
    _i1.ColumnSelections<ActionCategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActionCategory>(
      rows,
      columns: columns?.call(ActionCategory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionCategory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActionCategory> updateRow(
    _i1.Session session,
    ActionCategory row, {
    _i1.ColumnSelections<ActionCategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActionCategory>(
      row,
      columns: columns?.call(ActionCategory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionCategory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActionCategory?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActionCategoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ActionCategory>(
      id,
      columnValues: columnValues(ActionCategory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActionCategory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ActionCategory>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActionCategoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ActionCategoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionCategoryTable>? orderBy,
    _i1.OrderByListBuilder<ActionCategoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ActionCategory>(
      columnValues: columnValues(ActionCategory.t.updateTable),
      where: where(ActionCategory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionCategory.t),
      orderByList: orderByList?.call(ActionCategory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ActionCategory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActionCategory>> delete(
    _i1.Session session,
    List<ActionCategory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActionCategory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ActionCategory].
  Future<ActionCategory> deleteRow(
    _i1.Session session,
    ActionCategory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActionCategory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActionCategory>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionCategoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActionCategory>(
      where: where(ActionCategory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionCategoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActionCategory>(
      where: where?.call(ActionCategory.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
