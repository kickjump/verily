import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;

part 'search_provider.g.dart';

/// Searches actions by query string.
@riverpod
Future<List<vc.Action>> searchActions(Ref ref, String query) async {
  if (query.trim().isEmpty) return [];
  final client = ref.watch(serverpodClientProvider);
  return client.action.search(query);
}

/// Fetches all action categories.
@riverpod
Future<List<vc.ActionCategory>> actionCategories(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  return client.actionCategory.list();
}

/// Fetches actions filtered by category.
@riverpod
Future<List<vc.Action>> actionsByCategory(Ref ref, int categoryId) async {
  final client = ref.watch(serverpodClientProvider);
  return client.action.listByCategory(categoryId);
}
