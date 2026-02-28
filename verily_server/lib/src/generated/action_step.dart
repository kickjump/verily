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

abstract class ActionStep
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ActionStep._({
    this.id,
    required this.actionId,
    required this.stepNumber,
    required this.title,
    this.description,
    required this.verificationCriteria,
    this.locationId,
    required this.isOptional,
  });

  factory ActionStep({
    int? id,
    required int actionId,
    required int stepNumber,
    required String title,
    String? description,
    required String verificationCriteria,
    int? locationId,
    required bool isOptional,
  }) = _ActionStepImpl;

  factory ActionStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionStep(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      stepNumber: jsonSerialization['stepNumber'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      verificationCriteria: jsonSerialization['verificationCriteria'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      isOptional: jsonSerialization['isOptional'] as bool,
    );
  }

  static final t = ActionStepTable();

  static const db = ActionStepRepository._();

  @override
  int? id;

  int actionId;

  int stepNumber;

  String title;

  String? description;

  String verificationCriteria;

  int? locationId;

  bool isOptional;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionStep copyWith({
    int? id,
    int? actionId,
    int? stepNumber,
    String? title,
    String? description,
    String? verificationCriteria,
    int? locationId,
    bool? isOptional,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionStep',
      if (id != null) 'id': id,
      'actionId': actionId,
      'stepNumber': stepNumber,
      'title': title,
      if (description != null) 'description': description,
      'verificationCriteria': verificationCriteria,
      if (locationId != null) 'locationId': locationId,
      'isOptional': isOptional,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActionStep',
      if (id != null) 'id': id,
      'actionId': actionId,
      'stepNumber': stepNumber,
      'title': title,
      if (description != null) 'description': description,
      'verificationCriteria': verificationCriteria,
      if (locationId != null) 'locationId': locationId,
      'isOptional': isOptional,
    };
  }

  static ActionStepInclude include() {
    return ActionStepInclude._();
  }

  static ActionStepIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    ActionStepInclude? include,
  }) {
    return ActionStepIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionStep.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActionStep.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionStepImpl extends ActionStep {
  _ActionStepImpl({
    int? id,
    required int actionId,
    required int stepNumber,
    required String title,
    String? description,
    required String verificationCriteria,
    int? locationId,
    required bool isOptional,
  }) : super._(
         id: id,
         actionId: actionId,
         stepNumber: stepNumber,
         title: title,
         description: description,
         verificationCriteria: verificationCriteria,
         locationId: locationId,
         isOptional: isOptional,
       );

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionStep copyWith({
    Object? id = _Undefined,
    int? actionId,
    int? stepNumber,
    String? title,
    Object? description = _Undefined,
    String? verificationCriteria,
    Object? locationId = _Undefined,
    bool? isOptional,
  }) {
    return ActionStep(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      verificationCriteria: verificationCriteria ?? this.verificationCriteria,
      locationId: locationId is int? ? locationId : this.locationId,
      isOptional: isOptional ?? this.isOptional,
    );
  }
}

class ActionStepUpdateTable extends _i1.UpdateTable<ActionStepTable> {
  ActionStepUpdateTable(super.table);

  _i1.ColumnValue<int, int> actionId(int value) => _i1.ColumnValue(
    table.actionId,
    value,
  );

  _i1.ColumnValue<int, int> stepNumber(int value) => _i1.ColumnValue(
    table.stepNumber,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> verificationCriteria(String value) =>
      _i1.ColumnValue(
        table.verificationCriteria,
        value,
      );

  _i1.ColumnValue<int, int> locationId(int? value) => _i1.ColumnValue(
    table.locationId,
    value,
  );

  _i1.ColumnValue<bool, bool> isOptional(bool value) => _i1.ColumnValue(
    table.isOptional,
    value,
  );
}

class ActionStepTable extends _i1.Table<int?> {
  ActionStepTable({super.tableRelation}) : super(tableName: 'action_step') {
    updateTable = ActionStepUpdateTable(this);
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    stepNumber = _i1.ColumnInt(
      'stepNumber',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    verificationCriteria = _i1.ColumnString(
      'verificationCriteria',
      this,
    );
    locationId = _i1.ColumnInt(
      'locationId',
      this,
    );
    isOptional = _i1.ColumnBool(
      'isOptional',
      this,
    );
  }

  late final ActionStepUpdateTable updateTable;

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnInt stepNumber;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString verificationCriteria;

  late final _i1.ColumnInt locationId;

  late final _i1.ColumnBool isOptional;

  @override
  List<_i1.Column> get columns => [
    id,
    actionId,
    stepNumber,
    title,
    description,
    verificationCriteria,
    locationId,
    isOptional,
  ];
}

class ActionStepInclude extends _i1.IncludeObject {
  ActionStepInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ActionStep.t;
}

class ActionStepIncludeList extends _i1.IncludeList {
  ActionStepIncludeList._({
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActionStep.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ActionStep.t;
}

class ActionStepRepository {
  const ActionStepRepository._();

  /// Returns a list of [ActionStep]s matching the given query parameters.
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
  Future<List<ActionStep>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ActionStep>(
      where: where?.call(ActionStep.t),
      orderBy: orderBy?.call(ActionStep.t),
      orderByList: orderByList?.call(ActionStep.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ActionStep] matching the given query parameters.
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
  Future<ActionStep?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ActionStep>(
      where: where?.call(ActionStep.t),
      orderBy: orderBy?.call(ActionStep.t),
      orderByList: orderByList?.call(ActionStep.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ActionStep] by its [id] or null if no such row exists.
  Future<ActionStep?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ActionStep>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ActionStep]s in the list and returns the inserted rows.
  ///
  /// The returned [ActionStep]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActionStep>> insert(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActionStep>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ActionStep] and returns the inserted row.
  ///
  /// The returned [ActionStep] will have its `id` field set.
  Future<ActionStep> insertRow(
    _i1.Session session,
    ActionStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActionStep>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ActionStep]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActionStep>> update(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.ColumnSelections<ActionStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActionStep>(
      rows,
      columns: columns?.call(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionStep]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActionStep> updateRow(
    _i1.Session session,
    ActionStep row, {
    _i1.ColumnSelections<ActionStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActionStep>(
      row,
      columns: columns?.call(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionStep] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActionStep?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActionStepUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ActionStep>(
      id,
      columnValues: columnValues(ActionStep.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActionStep]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ActionStep>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActionStepUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ActionStepTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ActionStep>(
      columnValues: columnValues(ActionStep.t.updateTable),
      where: where(ActionStep.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionStep.t),
      orderByList: orderByList?.call(ActionStep.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ActionStep]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActionStep>> delete(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActionStep>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ActionStep].
  Future<ActionStep> deleteRow(
    _i1.Session session,
    ActionStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActionStep>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActionStep>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionStepTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActionStep>(
      where: where(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActionStep>(
      where: where?.call(ActionStep.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
