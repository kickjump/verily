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

abstract class Action implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Action._({
    this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.actionType,
    required this.status,
    this.locationId,
    this.categoryId,
    this.totalSteps,
    this.stepOrdering,
    this.intervalDays,
    this.habitDurationDays,
    this.habitFrequencyPerWeek,
    this.habitTotalRequired,
    this.maxPerformers,
    this.referenceImages,
    required this.verificationCriteria,
    this.tags,
    this.expiresAt,
    this.locationRadius,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Action({
    int? id,
    required String title,
    required String description,
    required _i1.UuidValue creatorId,
    required String actionType,
    required String status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    required String verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      creatorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      actionType: jsonSerialization['actionType'] as String,
      status: jsonSerialization['status'] as String,
      locationId: jsonSerialization['locationId'] as int?,
      categoryId: jsonSerialization['categoryId'] as int?,
      totalSteps: jsonSerialization['totalSteps'] as int?,
      stepOrdering: jsonSerialization['stepOrdering'] as String?,
      intervalDays: jsonSerialization['intervalDays'] as int?,
      habitDurationDays: jsonSerialization['habitDurationDays'] as int?,
      habitFrequencyPerWeek: jsonSerialization['habitFrequencyPerWeek'] as int?,
      habitTotalRequired: jsonSerialization['habitTotalRequired'] as int?,
      maxPerformers: jsonSerialization['maxPerformers'] as int?,
      referenceImages: jsonSerialization['referenceImages'] as String?,
      verificationCriteria: jsonSerialization['verificationCriteria'] as String,
      tags: jsonSerialization['tags'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      locationRadius: (jsonSerialization['locationRadius'] as num?)?.toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ActionTable();

  static const db = ActionRepository._();

  @override
  int? id;

  String title;

  String description;

  _i1.UuidValue creatorId;

  String actionType;

  String status;

  int? locationId;

  int? categoryId;

  int? totalSteps;

  String? stepOrdering;

  int? intervalDays;

  int? habitDurationDays;

  int? habitFrequencyPerWeek;

  int? habitTotalRequired;

  int? maxPerformers;

  String? referenceImages;

  String verificationCriteria;

  String? tags;

  DateTime? expiresAt;

  double? locationRadius;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    String? title,
    String? description,
    _i1.UuidValue? creatorId,
    String? actionType,
    String? status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    String? verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Action',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId.toJson(),
      'actionType': actionType,
      'status': status,
      if (locationId != null) 'locationId': locationId,
      if (categoryId != null) 'categoryId': categoryId,
      if (totalSteps != null) 'totalSteps': totalSteps,
      if (stepOrdering != null) 'stepOrdering': stepOrdering,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (habitDurationDays != null) 'habitDurationDays': habitDurationDays,
      if (habitFrequencyPerWeek != null)
        'habitFrequencyPerWeek': habitFrequencyPerWeek,
      if (habitTotalRequired != null) 'habitTotalRequired': habitTotalRequired,
      if (maxPerformers != null) 'maxPerformers': maxPerformers,
      if (referenceImages != null) 'referenceImages': referenceImages,
      'verificationCriteria': verificationCriteria,
      if (tags != null) 'tags': tags,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (locationRadius != null) 'locationRadius': locationRadius,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Action',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId.toJson(),
      'actionType': actionType,
      'status': status,
      if (locationId != null) 'locationId': locationId,
      if (categoryId != null) 'categoryId': categoryId,
      if (totalSteps != null) 'totalSteps': totalSteps,
      if (stepOrdering != null) 'stepOrdering': stepOrdering,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (habitDurationDays != null) 'habitDurationDays': habitDurationDays,
      if (habitFrequencyPerWeek != null)
        'habitFrequencyPerWeek': habitFrequencyPerWeek,
      if (habitTotalRequired != null) 'habitTotalRequired': habitTotalRequired,
      if (maxPerformers != null) 'maxPerformers': maxPerformers,
      if (referenceImages != null) 'referenceImages': referenceImages,
      'verificationCriteria': verificationCriteria,
      if (tags != null) 'tags': tags,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (locationRadius != null) 'locationRadius': locationRadius,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ActionInclude include() {
    return ActionInclude._();
  }

  static ActionIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    ActionInclude? include,
  }) {
    return ActionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Action.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Action.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required String title,
    required String description,
    required _i1.UuidValue creatorId,
    required String actionType,
    required String status,
    int? locationId,
    int? categoryId,
    int? totalSteps,
    String? stepOrdering,
    int? intervalDays,
    int? habitDurationDays,
    int? habitFrequencyPerWeek,
    int? habitTotalRequired,
    int? maxPerformers,
    String? referenceImages,
    required String verificationCriteria,
    String? tags,
    DateTime? expiresAt,
    double? locationRadius,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         description: description,
         creatorId: creatorId,
         actionType: actionType,
         status: status,
         locationId: locationId,
         categoryId: categoryId,
         totalSteps: totalSteps,
         stepOrdering: stepOrdering,
         intervalDays: intervalDays,
         habitDurationDays: habitDurationDays,
         habitFrequencyPerWeek: habitFrequencyPerWeek,
         habitTotalRequired: habitTotalRequired,
         maxPerformers: maxPerformers,
         referenceImages: referenceImages,
         verificationCriteria: verificationCriteria,
         tags: tags,
         expiresAt: expiresAt,
         locationRadius: locationRadius,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    _i1.UuidValue? creatorId,
    String? actionType,
    String? status,
    Object? locationId = _Undefined,
    Object? categoryId = _Undefined,
    Object? totalSteps = _Undefined,
    Object? stepOrdering = _Undefined,
    Object? intervalDays = _Undefined,
    Object? habitDurationDays = _Undefined,
    Object? habitFrequencyPerWeek = _Undefined,
    Object? habitTotalRequired = _Undefined,
    Object? maxPerformers = _Undefined,
    Object? referenceImages = _Undefined,
    String? verificationCriteria,
    Object? tags = _Undefined,
    Object? expiresAt = _Undefined,
    Object? locationRadius = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      actionType: actionType ?? this.actionType,
      status: status ?? this.status,
      locationId: locationId is int? ? locationId : this.locationId,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      totalSteps: totalSteps is int? ? totalSteps : this.totalSteps,
      stepOrdering: stepOrdering is String? ? stepOrdering : this.stepOrdering,
      intervalDays: intervalDays is int? ? intervalDays : this.intervalDays,
      habitDurationDays: habitDurationDays is int?
          ? habitDurationDays
          : this.habitDurationDays,
      habitFrequencyPerWeek: habitFrequencyPerWeek is int?
          ? habitFrequencyPerWeek
          : this.habitFrequencyPerWeek,
      habitTotalRequired: habitTotalRequired is int?
          ? habitTotalRequired
          : this.habitTotalRequired,
      maxPerformers: maxPerformers is int? ? maxPerformers : this.maxPerformers,
      referenceImages: referenceImages is String?
          ? referenceImages
          : this.referenceImages,
      verificationCriteria: verificationCriteria ?? this.verificationCriteria,
      tags: tags is String? ? tags : this.tags,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      locationRadius: locationRadius is double?
          ? locationRadius
          : this.locationRadius,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ActionUpdateTable extends _i1.UpdateTable<ActionTable> {
  ActionUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> creatorId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.creatorId,
    value,
  );

  _i1.ColumnValue<String, String> actionType(String value) => _i1.ColumnValue(
    table.actionType,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> locationId(int? value) => _i1.ColumnValue(
    table.locationId,
    value,
  );

  _i1.ColumnValue<int, int> categoryId(int? value) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<int, int> totalSteps(int? value) => _i1.ColumnValue(
    table.totalSteps,
    value,
  );

  _i1.ColumnValue<String, String> stepOrdering(String? value) =>
      _i1.ColumnValue(
        table.stepOrdering,
        value,
      );

  _i1.ColumnValue<int, int> intervalDays(int? value) => _i1.ColumnValue(
    table.intervalDays,
    value,
  );

  _i1.ColumnValue<int, int> habitDurationDays(int? value) => _i1.ColumnValue(
    table.habitDurationDays,
    value,
  );

  _i1.ColumnValue<int, int> habitFrequencyPerWeek(int? value) =>
      _i1.ColumnValue(
        table.habitFrequencyPerWeek,
        value,
      );

  _i1.ColumnValue<int, int> habitTotalRequired(int? value) => _i1.ColumnValue(
    table.habitTotalRequired,
    value,
  );

  _i1.ColumnValue<int, int> maxPerformers(int? value) => _i1.ColumnValue(
    table.maxPerformers,
    value,
  );

  _i1.ColumnValue<String, String> referenceImages(String? value) =>
      _i1.ColumnValue(
        table.referenceImages,
        value,
      );

  _i1.ColumnValue<String, String> verificationCriteria(String value) =>
      _i1.ColumnValue(
        table.verificationCriteria,
        value,
      );

  _i1.ColumnValue<String, String> tags(String? value) => _i1.ColumnValue(
    table.tags,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<double, double> locationRadius(double? value) =>
      _i1.ColumnValue(
        table.locationRadius,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ActionTable extends _i1.Table<int?> {
  ActionTable({super.tableRelation}) : super(tableName: 'action') {
    updateTable = ActionUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    creatorId = _i1.ColumnUuid(
      'creatorId',
      this,
    );
    actionType = _i1.ColumnString(
      'actionType',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    locationId = _i1.ColumnInt(
      'locationId',
      this,
    );
    categoryId = _i1.ColumnInt(
      'categoryId',
      this,
    );
    totalSteps = _i1.ColumnInt(
      'totalSteps',
      this,
    );
    stepOrdering = _i1.ColumnString(
      'stepOrdering',
      this,
    );
    intervalDays = _i1.ColumnInt(
      'intervalDays',
      this,
    );
    habitDurationDays = _i1.ColumnInt(
      'habitDurationDays',
      this,
    );
    habitFrequencyPerWeek = _i1.ColumnInt(
      'habitFrequencyPerWeek',
      this,
    );
    habitTotalRequired = _i1.ColumnInt(
      'habitTotalRequired',
      this,
    );
    maxPerformers = _i1.ColumnInt(
      'maxPerformers',
      this,
    );
    referenceImages = _i1.ColumnString(
      'referenceImages',
      this,
    );
    verificationCriteria = _i1.ColumnString(
      'verificationCriteria',
      this,
    );
    tags = _i1.ColumnString(
      'tags',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    locationRadius = _i1.ColumnDouble(
      'locationRadius',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ActionUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnUuid creatorId;

  late final _i1.ColumnString actionType;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt locationId;

  late final _i1.ColumnInt categoryId;

  late final _i1.ColumnInt totalSteps;

  late final _i1.ColumnString stepOrdering;

  late final _i1.ColumnInt intervalDays;

  late final _i1.ColumnInt habitDurationDays;

  late final _i1.ColumnInt habitFrequencyPerWeek;

  late final _i1.ColumnInt habitTotalRequired;

  late final _i1.ColumnInt maxPerformers;

  late final _i1.ColumnString referenceImages;

  late final _i1.ColumnString verificationCriteria;

  late final _i1.ColumnString tags;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDouble locationRadius;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    description,
    creatorId,
    actionType,
    status,
    locationId,
    categoryId,
    totalSteps,
    stepOrdering,
    intervalDays,
    habitDurationDays,
    habitFrequencyPerWeek,
    habitTotalRequired,
    maxPerformers,
    referenceImages,
    verificationCriteria,
    tags,
    expiresAt,
    locationRadius,
    createdAt,
    updatedAt,
  ];
}

class ActionInclude extends _i1.IncludeObject {
  ActionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Action.t;
}

class ActionIncludeList extends _i1.IncludeList {
  ActionIncludeList._({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Action.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Action.t;
}

class ActionRepository {
  const ActionRepository._();

  /// Returns a list of [Action]s matching the given query parameters.
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
  Future<List<Action>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Action] matching the given query parameters.
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
  Future<Action?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Action] by its [id] or null if no such row exists.
  Future<Action?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Action>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Action]s in the list and returns the inserted rows.
  ///
  /// The returned [Action]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Action>> insert(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Action] and returns the inserted row.
  ///
  /// The returned [Action] will have its `id` field set.
  Future<Action> insertRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Action]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Action>> update(
    _i1.Session session,
    List<Action> rows, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Action>(
      rows,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Action]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Action> updateRow(
    _i1.Session session,
    Action row, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Action>(
      row,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Action] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Action?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Action>(
      id,
      columnValues: columnValues(Action.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Action]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Action>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ActionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Action>(
      columnValues: columnValues(Action.t.updateTable),
      where: where(Action.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Action]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Action>> delete(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Action].
  Future<Action> deleteRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Action>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Action>(
      where: where(Action.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Action>(
      where: where?.call(Action.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
