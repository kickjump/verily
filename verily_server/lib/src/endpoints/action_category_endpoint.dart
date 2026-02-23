import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/action_category_service.dart';

/// Endpoint for managing action categories.
///
/// All methods require authentication. Categories are used to organize
/// and filter actions.
class ActionCategoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Lists all action categories, ordered by sort order.
  Future<List<ActionCategory>> list(Session session) async {
    return ActionCategoryService.list(session);
  }

  /// Creates a new action category.
  Future<ActionCategory> create(
    Session session,
    ActionCategory category,
  ) async {
    return ActionCategoryService.create(session, category);
  }

  /// Retrieves a single action category by its ID.
  Future<ActionCategory?> get(Session session, int id) async {
    return ActionCategoryService.get(session, id);
  }
}
