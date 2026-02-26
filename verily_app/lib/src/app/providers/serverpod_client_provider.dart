import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:verily_client/verily_client.dart';

part 'serverpod_client_provider.g.dart';

/// The default development server URL.
///
/// In production this should be replaced with the production endpoint via
/// environment configuration.
const _configuredServerUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

/// Resolves the configured Serverpod base URL with stable formatting.
String resolveServerUrl() {
  final trimmed = _configuredServerUrl.trim();
  if (trimmed.isEmpty) return 'http://localhost:8080/';
  return trimmed.endsWith('/') ? trimmed : '$trimmed/';
}

/// Provides the Serverpod [Client] used for all backend communication.
///
/// The client is initialized once and reused for the lifetime of the app.
@Riverpod(keepAlive: true)
Client serverpodClient(Ref ref) {
  final client = Client(resolveServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  ref.onDispose(client.close);

  return client;
}
