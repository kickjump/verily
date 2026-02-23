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
    final authId = session.authenticated!.userId;
    return ActionService.create(session, action, authId);
  }

  /// Lists all active actions.
  Future<List<Action>> listActive(Session session) async {
    return ActionService.listActive(session);
  }

  /// Lists actions near a geographic location.
  Future<List<Action>> listNearby(
    Session session,
    double lat,
    double lng,
    double radiusMeters,
  ) async {
    return ActionService.listNearby(session, lat, lng, radiusMeters);
  }

  /// Lists actions belonging to a specific category.
  Future<List<Action>> listByCategory(Session session, int categoryId) async {
    return ActionService.listByCategory(session, categoryId);
  }

  /// Searches actions by a query string.
  Future<List<Action>> search(Session session, String query) async {
    return ActionService.search(session, query);
  }

  /// Retrieves a single action by its ID.
  Future<Action?> get(Session session, int id) async {
    return ActionService.get(session, id);
  }

  /// Updates an existing action.
  Future<Action> update(Session session, Action action) async {
    final authId = session.authenticated!.userId;
    return ActionService.update(session, action, authId);
  }

  /// Deletes an action by its ID.
  Future<void> delete(Session session, int id) async {
    final authId = session.authenticated!.userId;
    return ActionService.delete(session, id, authId);
  }

  /// Lists all actions created by the authenticated user.
  Future<List<Action>> listByCreator(Session session) async {
    final authId = session.authenticated!.userId;
    return ActionService.listByCreator(session, authId);
  }
}
