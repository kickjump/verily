import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';

/// Business logic for managing action categories.
///
/// Categories are used to organize actions into groups (e.g. Fitness, Social,
/// Creative). All methods are static and accept a [Session] as the first
/// parameter.
class ActionCategoryService {
  ActionCategoryService._();

  static final _log = VLogger('ActionCategoryService');

  /// Creates a new category.
  ///
  /// The [name] must be unique. Throws [ValidationException] if a category
  /// with the same name already exists.
  static Future<ActionCategory> create(
    Session session, {
    required String name,
    required int sortOrder,
    String? description,
    String? iconName,
  }) async {
    // Check uniqueness.
    final existing = await findByName(session, name);
    if (existing != null) {
      throw ValidationException('Category "$name" already exists');
    }

    final category = ActionCategory(
      name: name,
      description: description,
      iconName: iconName,
      sortOrder: sortOrder,
    );

    final inserted = await ActionCategory.db.insertRow(session, category);
    _log.info('Created category "${inserted.name}" (id=${inserted.id})');
    return inserted;
  }

  /// Returns all categories ordered by [sortOrder].
  static Future<List<ActionCategory>> listAll(Session session) async {
    return ActionCategory.db.find(session, orderBy: (t) => t.sortOrder);
  }

  /// Finds a category by its primary key [id].
  ///
  /// Throws [NotFoundException] if not found.
  static Future<ActionCategory> findById(Session session, int id) async {
    final category = await ActionCategory.db.findById(session, id);
    if (category == null) {
      throw NotFoundException('Category with id $id not found');
    }
    return category;
  }

  /// Finds a category by its unique [name], or returns `null`.
  static Future<ActionCategory?> findByName(
    Session session,
    String name,
  ) async {
    final results = await ActionCategory.db.find(
      session,
      where: (t) => t.name.equals(name),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  /// Updates a category's fields.
  static Future<ActionCategory> update(
    Session session, {
    required int id,
    String? name,
    String? description,
    String? iconName,
    int? sortOrder,
  }) async {
    final category = await findById(session, id);

    if (name != null) {
      // Verify uniqueness if name is changing.
      if (name != category.name) {
        final existing = await findByName(session, name);
        if (existing != null) {
          throw ValidationException('Category "$name" already exists');
        }
      }
      category.name = name;
    }

    if (description != null) category.description = description;
    if (iconName != null) category.iconName = iconName;
    if (sortOrder != null) category.sortOrder = sortOrder;

    return ActionCategory.db.updateRow(session, category);
  }

  /// Deletes a category by its primary key [id].
  ///
  /// Actions referencing this category will have their [categoryId] set to
  /// null due to the `onDelete: setNull` relation.
  static Future<void> delete(Session session, int id) async {
    final category = await findById(session, id);
    await ActionCategory.db.deleteRow(session, category);
    _log.info('Deleted category id=$id ("${category.name}")');
  }

  /// Ensures the default set of categories exist.
  ///
  /// This is intended to be called during server startup or seeding.
  static Future<void> ensureDefaults(Session session) async {
    const defaults = [
      (
        'Fitness',
        'Physical exercise and movement challenges',
        'fitness_center',
        0,
      ),
      ('Social', 'Challenges involving interaction with others', 'people', 1),
      ('Creative', 'Artistic and creative challenges', 'palette', 2),
      (
        'Wellness',
        'Mental health and well-being challenges',
        'self_improvement',
        3,
      ),
    ];

    for (final (name, description, iconName, sortOrder) in defaults) {
      final existing = await findByName(session, name);
      if (existing == null) {
        await create(
          session,
          name: name,
          description: description,
          iconName: iconName,
          sortOrder: sortOrder,
        );
      }
    }

    _log.info('Default categories ensured');
  }
}
