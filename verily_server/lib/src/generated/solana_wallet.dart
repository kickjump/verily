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

abstract class SolanaWallet
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SolanaWallet._({
    this.id,
    required this.userId,
    required this.publicKey,
    required this.walletType,
    required this.isDefault,
    this.label,
    required this.createdAt,
  });

  factory SolanaWallet({
    int? id,
    required _i1.UuidValue userId,
    required String publicKey,
    required String walletType,
    required bool isDefault,
    String? label,
    required DateTime createdAt,
  }) = _SolanaWalletImpl;

  factory SolanaWallet.fromJson(Map<String, dynamic> jsonSerialization) {
    return SolanaWallet(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      publicKey: jsonSerialization['publicKey'] as String,
      walletType: jsonSerialization['walletType'] as String,
      isDefault: jsonSerialization['isDefault'] as bool,
      label: jsonSerialization['label'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SolanaWalletTable();

  static const db = SolanaWalletRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  String publicKey;

  String walletType;

  bool isDefault;

  String? label;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SolanaWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SolanaWallet copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? publicKey,
    String? walletType,
    bool? isDefault,
    String? label,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SolanaWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'publicKey': publicKey,
      'walletType': walletType,
      'isDefault': isDefault,
      if (label != null) 'label': label,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SolanaWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'publicKey': publicKey,
      'walletType': walletType,
      'isDefault': isDefault,
      if (label != null) 'label': label,
      'createdAt': createdAt.toJson(),
    };
  }

  static SolanaWalletInclude include() {
    return SolanaWalletInclude._();
  }

  static SolanaWalletIncludeList includeList({
    _i1.WhereExpressionBuilder<SolanaWalletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SolanaWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SolanaWalletTable>? orderByList,
    SolanaWalletInclude? include,
  }) {
    return SolanaWalletIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SolanaWallet.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SolanaWallet.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SolanaWalletImpl extends SolanaWallet {
  _SolanaWalletImpl({
    int? id,
    required _i1.UuidValue userId,
    required String publicKey,
    required String walletType,
    required bool isDefault,
    String? label,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         publicKey: publicKey,
         walletType: walletType,
         isDefault: isDefault,
         label: label,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SolanaWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SolanaWallet copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? publicKey,
    String? walletType,
    bool? isDefault,
    Object? label = _Undefined,
    DateTime? createdAt,
  }) {
    return SolanaWallet(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      publicKey: publicKey ?? this.publicKey,
      walletType: walletType ?? this.walletType,
      isDefault: isDefault ?? this.isDefault,
      label: label is String? ? label : this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SolanaWalletUpdateTable extends _i1.UpdateTable<SolanaWalletTable> {
  SolanaWalletUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> publicKey(String value) => _i1.ColumnValue(
    table.publicKey,
    value,
  );

  _i1.ColumnValue<String, String> walletType(String value) => _i1.ColumnValue(
    table.walletType,
    value,
  );

  _i1.ColumnValue<bool, bool> isDefault(bool value) => _i1.ColumnValue(
    table.isDefault,
    value,
  );

  _i1.ColumnValue<String, String> label(String? value) => _i1.ColumnValue(
    table.label,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class SolanaWalletTable extends _i1.Table<int?> {
  SolanaWalletTable({super.tableRelation}) : super(tableName: 'solana_wallet') {
    updateTable = SolanaWalletUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    publicKey = _i1.ColumnString(
      'publicKey',
      this,
    );
    walletType = _i1.ColumnString(
      'walletType',
      this,
    );
    isDefault = _i1.ColumnBool(
      'isDefault',
      this,
    );
    label = _i1.ColumnString(
      'label',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SolanaWalletUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString publicKey;

  late final _i1.ColumnString walletType;

  late final _i1.ColumnBool isDefault;

  late final _i1.ColumnString label;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    publicKey,
    walletType,
    isDefault,
    label,
    createdAt,
  ];
}

class SolanaWalletInclude extends _i1.IncludeObject {
  SolanaWalletInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SolanaWallet.t;
}

class SolanaWalletIncludeList extends _i1.IncludeList {
  SolanaWalletIncludeList._({
    _i1.WhereExpressionBuilder<SolanaWalletTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SolanaWallet.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SolanaWallet.t;
}

class SolanaWalletRepository {
  const SolanaWalletRepository._();

  /// Returns a list of [SolanaWallet]s matching the given query parameters.
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
  Future<List<SolanaWallet>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SolanaWalletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SolanaWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SolanaWalletTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SolanaWallet>(
      where: where?.call(SolanaWallet.t),
      orderBy: orderBy?.call(SolanaWallet.t),
      orderByList: orderByList?.call(SolanaWallet.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SolanaWallet] matching the given query parameters.
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
  Future<SolanaWallet?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SolanaWalletTable>? where,
    int? offset,
    _i1.OrderByBuilder<SolanaWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SolanaWalletTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SolanaWallet>(
      where: where?.call(SolanaWallet.t),
      orderBy: orderBy?.call(SolanaWallet.t),
      orderByList: orderByList?.call(SolanaWallet.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SolanaWallet] by its [id] or null if no such row exists.
  Future<SolanaWallet?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SolanaWallet>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SolanaWallet]s in the list and returns the inserted rows.
  ///
  /// The returned [SolanaWallet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SolanaWallet>> insert(
    _i1.Session session,
    List<SolanaWallet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SolanaWallet>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SolanaWallet] and returns the inserted row.
  ///
  /// The returned [SolanaWallet] will have its `id` field set.
  Future<SolanaWallet> insertRow(
    _i1.Session session,
    SolanaWallet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SolanaWallet>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SolanaWallet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SolanaWallet>> update(
    _i1.Session session,
    List<SolanaWallet> rows, {
    _i1.ColumnSelections<SolanaWalletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SolanaWallet>(
      rows,
      columns: columns?.call(SolanaWallet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SolanaWallet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SolanaWallet> updateRow(
    _i1.Session session,
    SolanaWallet row, {
    _i1.ColumnSelections<SolanaWalletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SolanaWallet>(
      row,
      columns: columns?.call(SolanaWallet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SolanaWallet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SolanaWallet?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SolanaWalletUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SolanaWallet>(
      id,
      columnValues: columnValues(SolanaWallet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SolanaWallet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SolanaWallet>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SolanaWalletUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SolanaWalletTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SolanaWalletTable>? orderBy,
    _i1.OrderByListBuilder<SolanaWalletTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SolanaWallet>(
      columnValues: columnValues(SolanaWallet.t.updateTable),
      where: where(SolanaWallet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SolanaWallet.t),
      orderByList: orderByList?.call(SolanaWallet.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SolanaWallet]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SolanaWallet>> delete(
    _i1.Session session,
    List<SolanaWallet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SolanaWallet>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SolanaWallet].
  Future<SolanaWallet> deleteRow(
    _i1.Session session,
    SolanaWallet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SolanaWallet>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SolanaWallet>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SolanaWalletTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SolanaWallet>(
      where: where(SolanaWallet.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SolanaWalletTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SolanaWallet>(
      where: where?.call(SolanaWallet.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
