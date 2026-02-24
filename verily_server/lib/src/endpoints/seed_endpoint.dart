import 'package:serverpod/serverpod.dart';

import '../services/seed_service.dart';

/// Endpoint for seeding the database with default data.
///
/// All methods require authentication. This is intended for administrative
/// use to populate the database with initial action definitions and
/// categories.
class SeedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Seeds the database with default actions and their associated
  /// categories, steps, and rewards.
  Future<void> seedDefaultActions(Session session) async {
    return SeedService.seedAll(session);
  }
}
