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

abstract class ActionSubmission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ActionSubmission._({
    this.id,
    required this.actionId,
    required this.performerId,
    this.stepNumber,
    required this.videoUrl,
    this.videoDurationSeconds,
    this.deviceMetadata,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActionSubmission({
    int? id,
    required int actionId,
    required _i1.UuidValue performerId,
    int? stepNumber,
    required String videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionSubmissionImpl;

  factory ActionSubmission.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionSubmission(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      performerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['performerId'],
      ),
      stepNumber: jsonSerialization['stepNumber'] as int?,
      videoUrl: jsonSerialization['videoUrl'] as String,
      videoDurationSeconds: (jsonSerialization['videoDurationSeconds'] as num?)
          ?.toDouble(),
      deviceMetadata: jsonSerialization['deviceMetadata'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ActionSubmissionTable();

  static const db = ActionSubmissionRepository._();

  @override
  int? id;

  int actionId;

  _i1.UuidValue performerId;

  int? stepNumber;

  String videoUrl;

  double? videoDurationSeconds;

  String? deviceMetadata;

  double? latitude;

  double? longitude;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActionSubmission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionSubmission copyWith({
    int? id,
    int? actionId,
    _i1.UuidValue? performerId,
    int? stepNumber,
    String? videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionSubmission',
      if (id != null) 'id': id,
      'actionId': actionId,
      'performerId': performerId.toJson(),
      if (stepNumber != null) 'stepNumber': stepNumber,
      'videoUrl': videoUrl,
      if (videoDurationSeconds != null)
        'videoDurationSeconds': videoDurationSeconds,
      if (deviceMetadata != null) 'deviceMetadata': deviceMetadata,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActionSubmission',
      if (id != null) 'id': id,
      'actionId': actionId,
      'performerId': performerId.toJson(),
      if (stepNumber != null) 'stepNumber': stepNumber,
      'videoUrl': videoUrl,
      if (videoDurationSeconds != null)
        'videoDurationSeconds': videoDurationSeconds,
      if (deviceMetadata != null) 'deviceMetadata': deviceMetadata,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ActionSubmissionInclude include() {
    return ActionSubmissionInclude._();
  }

  static ActionSubmissionIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionSubmissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionSubmissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionSubmissionTable>? orderByList,
    ActionSubmissionInclude? include,
  }) {
    return ActionSubmissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionSubmission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActionSubmission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionSubmissionImpl extends ActionSubmission {
  _ActionSubmissionImpl({
    int? id,
    required int actionId,
    required _i1.UuidValue performerId,
    int? stepNumber,
    required String videoUrl,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         actionId: actionId,
         performerId: performerId,
         stepNumber: stepNumber,
         videoUrl: videoUrl,
         videoDurationSeconds: videoDurationSeconds,
         deviceMetadata: deviceMetadata,
         latitude: latitude,
         longitude: longitude,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ActionSubmission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionSubmission copyWith({
    Object? id = _Undefined,
    int? actionId,
    _i1.UuidValue? performerId,
    Object? stepNumber = _Undefined,
    String? videoUrl,
    Object? videoDurationSeconds = _Undefined,
    Object? deviceMetadata = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActionSubmission(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      performerId: performerId ?? this.performerId,
      stepNumber: stepNumber is int? ? stepNumber : this.stepNumber,
      videoUrl: videoUrl ?? this.videoUrl,
      videoDurationSeconds: videoDurationSeconds is double?
          ? videoDurationSeconds
          : this.videoDurationSeconds,
      deviceMetadata: deviceMetadata is String?
          ? deviceMetadata
          : this.deviceMetadata,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ActionSubmissionUpdateTable
    extends _i1.UpdateTable<ActionSubmissionTable> {
  ActionSubmissionUpdateTable(super.table);

  _i1.ColumnValue<int, int> actionId(int value) => _i1.ColumnValue(
    table.actionId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> performerId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.performerId,
    value,
  );

  _i1.ColumnValue<int, int> stepNumber(int? value) => _i1.ColumnValue(
    table.stepNumber,
    value,
  );

  _i1.ColumnValue<String, String> videoUrl(String value) => _i1.ColumnValue(
    table.videoUrl,
    value,
  );

  _i1.ColumnValue<double, double> videoDurationSeconds(double? value) =>
      _i1.ColumnValue(
        table.videoDurationSeconds,
        value,
      );

  _i1.ColumnValue<String, String> deviceMetadata(String? value) =>
      _i1.ColumnValue(
        table.deviceMetadata,
        value,
      );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ActionSubmissionTable extends _i1.Table<int?> {
  ActionSubmissionTable({super.tableRelation})
    : super(tableName: 'action_submission') {
    updateTable = ActionSubmissionUpdateTable(this);
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    performerId = _i1.ColumnUuid(
      'performerId',
      this,
    );
    stepNumber = _i1.ColumnInt(
      'stepNumber',
      this,
    );
    videoUrl = _i1.ColumnString(
      'videoUrl',
      this,
    );
    videoDurationSeconds = _i1.ColumnDouble(
      'videoDurationSeconds',
      this,
    );
    deviceMetadata = _i1.ColumnString(
      'deviceMetadata',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ActionSubmissionUpdateTable updateTable;

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnUuid performerId;

  late final _i1.ColumnInt stepNumber;

  late final _i1.ColumnString videoUrl;

  late final _i1.ColumnDouble videoDurationSeconds;

  late final _i1.ColumnString deviceMetadata;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column<dynamic>> get columns => [
    id,
    actionId,
    performerId,
    stepNumber,
    videoUrl,
    videoDurationSeconds,
    deviceMetadata,
    latitude,
    longitude,
    status,
    createdAt,
    updatedAt,
  ];
}

class ActionSubmissionInclude extends _i1.IncludeObject {
  ActionSubmissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ActionSubmission.t;
}

class ActionSubmissionIncludeList extends _i1.IncludeList {
  ActionSubmissionIncludeList._({
    _i1.WhereExpressionBuilder<ActionSubmissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActionSubmission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ActionSubmission.t;
}

class ActionSubmissionRepository {
  const ActionSubmissionRepository._();

  /// Returns a list of [ActionSubmission]s matching the given query parameters.
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
  Future<List<ActionSubmission>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionSubmissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionSubmissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionSubmissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ActionSubmission>(
      where: where?.call(ActionSubmission.t),
      orderBy: orderBy?.call(ActionSubmission.t),
      orderByList: orderByList?.call(ActionSubmission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ActionSubmission] matching the given query parameters.
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
  Future<ActionSubmission?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionSubmissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionSubmissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionSubmissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ActionSubmission>(
      where: where?.call(ActionSubmission.t),
      orderBy: orderBy?.call(ActionSubmission.t),
      orderByList: orderByList?.call(ActionSubmission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ActionSubmission] by its [id] or null if no such row exists.
  Future<ActionSubmission?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ActionSubmission>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ActionSubmission]s in the list and returns the inserted rows.
  ///
  /// The returned [ActionSubmission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActionSubmission>> insert(
    _i1.Session session,
    List<ActionSubmission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActionSubmission>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ActionSubmission] and returns the inserted row.
  ///
  /// The returned [ActionSubmission] will have its `id` field set.
  Future<ActionSubmission> insertRow(
    _i1.Session session,
    ActionSubmission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActionSubmission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ActionSubmission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActionSubmission>> update(
    _i1.Session session,
    List<ActionSubmission> rows, {
    _i1.ColumnSelections<ActionSubmissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActionSubmission>(
      rows,
      columns: columns?.call(ActionSubmission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionSubmission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActionSubmission> updateRow(
    _i1.Session session,
    ActionSubmission row, {
    _i1.ColumnSelections<ActionSubmissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActionSubmission>(
      row,
      columns: columns?.call(ActionSubmission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionSubmission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActionSubmission?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActionSubmissionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ActionSubmission>(
      id,
      columnValues: columnValues(ActionSubmission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActionSubmission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ActionSubmission>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActionSubmissionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ActionSubmissionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionSubmissionTable>? orderBy,
    _i1.OrderByListBuilder<ActionSubmissionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ActionSubmission>(
      columnValues: columnValues(ActionSubmission.t.updateTable),
      where: where(ActionSubmission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionSubmission.t),
      orderByList: orderByList?.call(ActionSubmission.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ActionSubmission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActionSubmission>> delete(
    _i1.Session session,
    List<ActionSubmission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActionSubmission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ActionSubmission].
  Future<ActionSubmission> deleteRow(
    _i1.Session session,
    ActionSubmission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActionSubmission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActionSubmission>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionSubmissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActionSubmission>(
      where: where(ActionSubmission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionSubmissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActionSubmission>(
      where: where?.call(ActionSubmission.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
