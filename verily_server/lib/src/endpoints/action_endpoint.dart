import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/action_service.dart';

/// Endpoint for managing verifiable actions.
///
/// All methods require authentication. Actions represent tasks that users
/// create for others to perform and verify.
class ActionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new action.
  Future<Action> create(Session session, Action action) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return ActionService.create(
      session,
      title: action.title,
      description: action.description,
      creatorId: authId,
      actionType: action.actionType,
      verificationCriteria: action.verificationCriteria,
      totalSteps: action.totalSteps,
      intervalDays: action.intervalDays,
      maxPerformers: action.maxPerformers,
      locationId: action.locationId,
      categoryId: action.categoryId,
      referenceImages: action.referenceImages,
    );
  }

  /// Lists all active actions.
  Future<List<Action>> listActive(Session session) async {
    return ActionService.list(session, status: 'active');
  }

  /// Lists actions near a geographic location.
  Future<List<Action>> listNearby(
    Session session,
    double lat,
    double lng,
    double radiusMeters,
  ) async {
    return ActionService.listNearby(
      session,
      latitude: lat,
      longitude: lng,
      radiusMeters: radiusMeters,
    );
  }

  /// Lists active actions with locations inside a bounding box.
  Future<List<Action>> listInBoundingBox(
    Session session,
    double southLat,
    double westLng,
    double northLat,
    double eastLng,
  ) async {
    return ActionService.listInBoundingBox(
      session,
      southLat: southLat,
      westLng: westLng,
      northLat: northLat,
      eastLng: eastLng,
    );
  }

  /// Lists actions belonging to a specific category.
  Future<List<Action>> listByCategory(Session session, int categoryId) async {
    return ActionService.list(session, categoryId: categoryId);
  }

  /// Searches actions by a query string.
  Future<List<Action>> search(Session session, String query) async {
    return ActionService.search(session, query: query);
  }

  /// Retrieves a single action by its ID.
  Future<Action?> get(Session session, int id) async {
    return ActionService.findById(session, id);
  }

  /// Updates an existing action.
  Future<Action> update(Session session, Action action) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return ActionService.update(
      session,
      id: action.id!,
      callerId: authId,
      title: action.title,
      description: action.description,
      status: action.status,
      verificationCriteria: action.verificationCriteria,
      totalSteps: action.totalSteps,
      intervalDays: action.intervalDays,
      maxPerformers: action.maxPerformers,
      locationId: action.locationId,
      categoryId: action.categoryId,
      referenceImages: action.referenceImages,
    );
  }

  /// Deletes an action by its ID.
  Future<void> delete(Session session, int id) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return ActionService.delete(session, id: id, callerId: authId);
  }

  /// Lists all actions created by the authenticated user.
  Future<List<Action>> listByCreator(Session session) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return ActionService.findByCreator(session, creatorId: authId);
  }
}
