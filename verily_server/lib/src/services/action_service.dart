import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';
import 'location_service.dart';

/// Business logic for creating, reading, updating, and deleting actions.
///
/// All methods are static and accept a [Session] as the first parameter for
/// database access and authentication context.
class ActionService {
  ActionService._();

  static final _log = VLogger('ActionService');

  /// Creates a new action owned by the authenticated user.
  ///
  /// The [actionType] must be a valid [ActionType] value. For sequential
  /// actions, [totalSteps] must be provided and be greater than zero.
  static Future<Action> create(
    Session session, {
    required String title,
    required String description,
    required UuidValue creatorId,
    required String actionType,
    required String verificationCriteria,
    int? totalSteps,
    int? intervalDays,
    int? maxPerformers,
    int? locationId,
    int? categoryId,
    String? referenceImages,
  }) async {
    // Validate action type.
    final type = ActionType.fromValue(actionType);

    if (type == ActionType.sequential &&
        (totalSteps == null || totalSteps < 1)) {
      throw ValidationException('Sequential actions must have totalSteps >= 1');
    }

    final now = DateTime.now().toUtc();
    final action = Action(
      title: title,
      description: description,
      creatorId: creatorId,
      actionType: actionType,
      status: 'active',
      verificationCriteria: verificationCriteria,
      totalSteps: totalSteps,
      intervalDays: intervalDays,
      maxPerformers: maxPerformers,
      locationId: locationId,
      categoryId: categoryId,
      referenceImages: referenceImages,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await Action.db.insertRow(session, action);
    _log.info('Created action "${inserted.title}" (id=${inserted.id})');
    return inserted;
  }

  /// Retrieves an action by its primary key [id].
  ///
  /// Throws [NotFoundException] if the action does not exist.
  static Future<Action> findById(Session session, int id) async {
    final action = await Action.db.findById(session, id);
    if (action == null) {
      throw NotFoundException('Action with id $id not found');
    }
    return action;
  }

  /// Lists actions with optional filtering and pagination.
  ///
  /// When [status] is provided only actions with that status are returned.
  /// When [categoryId] is provided only actions in that category are returned.
  /// When [creatorId] is provided only actions by that user are returned.
  static Future<List<Action>> list(
    Session session, {
    String? status,
    int? categoryId,
    UuidValue? creatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    // TODO: Use generated where-clause builders once `serverpod generate` runs.
    // For now we build a manual filter using the generated Action.t table.
    final where = Action.t.id.notEquals(null);

    // Chain additional filters when provided.
    var filter = where;
    if (status != null) {
      filter = filter & Action.t.status.equals(status);
    }
    if (categoryId != null) {
      filter = filter & Action.t.categoryId.equals(categoryId);
    }
    if (creatorId != null) {
      filter = filter & Action.t.creatorId.equals(creatorId);
    }

    return Action.db.find(
      session,
      where: (_) => filter,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Searches actions by a text query against the title and description.
  static Future<List<Action>> search(
    Session session, {
    required String query,
    int limit = 20,
  }) async {
    // TODO: Replace with full-text search or ILIKE once generated column
    // references are available.
    final lowerQuery = query.toLowerCase();
    final all = await Action.db.find(
      session,
      where: (t) =>
          t.title.like('%$lowerQuery%') | t.description.like('%$lowerQuery%'),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return all;
  }

  /// Updates selected fields of an action.
  ///
  /// Only the creator (verified via [callerId]) may update an action.
  /// Throws [ForbiddenException] if the caller is not the owner.
  static Future<Action> update(
    Session session, {
    required int id,
    required UuidValue callerId,
    String? title,
    String? description,
    String? status,
    String? verificationCriteria,
    int? totalSteps,
    int? intervalDays,
    int? maxPerformers,
    int? locationId,
    int? categoryId,
    String? referenceImages,
  }) async {
    final action = await findById(session, id);
    _verifyOwnership(action, callerId);

    if (title != null) action.title = title;
    if (description != null) action.description = description;
    if (status != null) action.status = status;
    if (verificationCriteria != null) {
      action.verificationCriteria = verificationCriteria;
    }
    if (totalSteps != null) action.totalSteps = totalSteps;
    if (intervalDays != null) action.intervalDays = intervalDays;
    if (maxPerformers != null) action.maxPerformers = maxPerformers;
    if (locationId != null) action.locationId = locationId;
    if (categoryId != null) action.categoryId = categoryId;
    if (referenceImages != null) action.referenceImages = referenceImages;
    action.updatedAt = DateTime.now().toUtc();

    return Action.db.updateRow(session, action);
  }

  /// Soft-deletes an action by setting its status to `archived`.
  ///
  /// Only the creator (verified via [callerId]) may archive an action.
  static Future<Action> archive(
    Session session, {
    required int id,
    required UuidValue callerId,
  }) async {
    final action = await findById(session, id);
    _verifyOwnership(action, callerId);

    action.status = 'archived';
    action.updatedAt = DateTime.now().toUtc();
    return Action.db.updateRow(session, action);
  }

  /// Hard-deletes an action and all associated records (steps, submissions,
  /// rewards) via cascading deletes.
  ///
  /// Only the creator (verified via [callerId]) may delete an action.
  static Future<void> delete(
    Session session, {
    required int id,
    required UuidValue callerId,
  }) async {
    final action = await findById(session, id);
    _verifyOwnership(action, callerId);

    await Action.db.deleteRow(session, action);
    _log.info('Deleted action id=$id');
  }

  /// Finds active actions with a location within [radiusMeters] of the given
  /// point.
  static Future<List<Action>> listNearby(
    Session session, {
    required double latitude,
    required double longitude,
    required double radiusMeters,
    int limit = 50,
  }) async {
    final nearbyLocations = await LocationService.findNearby(
      session,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );
    final locationIds = nearbyLocations.map((l) => l.id!).toList();
    if (locationIds.isEmpty) return [];

    return Action.db.find(
      session,
      where: (t) =>
          t.status.equals('active') & t.locationId.inSet(locationIds.toSet()),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Finds active actions with locations inside the given bounding box.
  static Future<List<Action>> listInBoundingBox(
    Session session, {
    required double southLat,
    required double westLng,
    required double northLat,
    required double eastLng,
    int limit = 100,
  }) async {
    final locations = await LocationService.findInBoundingBox(
      session,
      southLat: southLat,
      westLng: westLng,
      northLat: northLat,
      eastLng: eastLng,
    );
    final locationIds = locations.map((l) => l.id!).toList();
    if (locationIds.isEmpty) return [];

    return Action.db.find(
      session,
      where: (t) =>
          t.status.equals('active') & t.locationId.inSet(locationIds.toSet()),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Verifies that [callerId] matches the action's [creatorId].
  ///
  /// Throws [ForbiddenException] when they do not match.
  static void _verifyOwnership(Action action, UuidValue callerId) {
    if (action.creatorId != callerId) {
      throw ForbiddenException('You do not own this action');
    }
  }

  /// Counts the total number of active actions.
  static Future<int> countActive(Session session) async {
    return Action.db.count(session, where: (t) => t.status.equals('active'));
  }

  /// Returns the actions created by a specific user.
  static Future<List<Action>> findByCreator(
    Session session, {
    required UuidValue creatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    return Action.db.find(
      session,
      where: (t) => t.creatorId.equals(creatorId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}
