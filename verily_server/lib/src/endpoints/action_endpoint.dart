import 'package:serverpod/serverpod.dart';
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/action_service.dart';
import 'package:verily_server/src/services/location_service.dart';

/// Endpoint for managing verifiable actions.
///
/// All methods require authentication. Actions represent tasks that users
/// create for others to perform and verify.
class ActionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new action.
  Future<Action> create(Session session, Action action) async {
    final authId = _authenticatedUserId(session);
    return ActionService.create(
      session,
      title: action.title,
      description: action.description,
      creatorId: authId,
      actionType: action.actionType,
      verificationCriteria: action.verificationCriteria,
      totalSteps: action.totalSteps,
      stepOrdering: action.stepOrdering,
      intervalDays: action.intervalDays,
      habitDurationDays: action.habitDurationDays,
      habitFrequencyPerWeek: action.habitFrequencyPerWeek,
      habitTotalRequired: action.habitTotalRequired,
      maxPerformers: action.maxPerformers,
      locationId: action.locationId,
      categoryId: action.categoryId,
      referenceImages: action.referenceImages,
      tags: action.tags,
      expiresAt: action.expiresAt,
      locationRadius: action.locationRadius,
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
    final nearbyLocations = await LocationService.findNearby(
      session,
      latitude: lat,
      longitude: lng,
      radiusMeters: radiusMeters,
      limit: 200,
    );
    final nearbyLocationIds = nearbyLocations.map((l) => l.id).whereType<int>();
    final nearbySet = nearbyLocationIds.toSet();
    if (nearbySet.isEmpty) return [];

    final activeActions = await ActionService.list(
      session,
      status: 'active',
      limit: 500,
    );
    return activeActions
        .where(
          (action) =>
              action.locationId != null &&
              nearbySet.contains(action.locationId),
        )
        .toList();
  }

  /// Lists actions that have locations inside a bounding box.
  Future<List<Action>> listInBoundingBox(
    Session session,
    double southLat,
    double westLng,
    double northLat,
    double eastLng,
  ) async {
    final locations = await LocationService.list(session, limit: 2000);
    final locationIds = locations
        .where(
          (location) =>
              location.latitude >= southLat &&
              location.latitude <= northLat &&
              location.longitude >= westLng &&
              location.longitude <= eastLng,
        )
        .map((location) => location.id)
        .whereType<int>()
        .toSet();

    if (locationIds.isEmpty) return [];

    final activeActions = await ActionService.list(
      session,
      status: 'active',
      limit: 500,
    );
    return activeActions
        .where(
          (action) =>
              action.locationId != null &&
              locationIds.contains(action.locationId),
        )
        .toList();
  }

  /// Lists actions belonging to a specific category.
  Future<List<Action>> listByCategory(Session session, int categoryId) async {
    return ActionService.list(
      session,
      status: 'active',
      categoryId: categoryId,
    );
  }

  /// Searches actions by a query string.
  Future<List<Action>> search(Session session, String query) async {
    return ActionService.search(session, query: query);
  }

  /// Retrieves a single action by its ID.
  Future<Action> get(Session session, int id) async {
    return ActionService.findById(session, id);
  }

  /// Updates an existing action.
  Future<Action> update(Session session, Action action) async {
    final authId = _authenticatedUserId(session);
    final actionId = action.id;
    if (actionId == null) {
      throw ArgumentError('Action id is required for updates');
    }

    return ActionService.update(
      session,
      id: actionId,
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
    final authId = _authenticatedUserId(session);
    return ActionService.delete(session, id: id, callerId: authId);
  }

  /// Lists all actions created by the authenticated user.
  Future<List<Action>> listByCreator(Session session) async {
    final authId = _authenticatedUserId(session);
    return ActionService.findByCreator(session, creatorId: authId);
  }
}

UuidValue _authenticatedUserId(Session session) {
  return UuidValue.fromString(session.authenticated!.userIdentifier);
}
