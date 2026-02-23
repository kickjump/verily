import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:verily_client/verily_client.dart';

part 'serverpod_client_provider.g.dart';

/// The default development server URL.
///
/// In production this should be replaced with the production endpoint via
/// environment configuration.
const _devServerUrl = 'http://localhost:8080/';

/// Provides the Serverpod [Client] used for all backend communication.
///
/// The client is initialized once and reused for the lifetime of the app.
/// [SessionManager] is attached so that authentication tokens are
/// automatically included in every request.
@Riverpod(keepAlive: true)
Client serverpodClient(ServerpodClientRef ref) {
  final sessionManager = SessionManager(caller: FlutterConnectivityMonitor());

  final client = Client(
    _devServerUrl,
    authenticationKeyManager: sessionManager,
  )..connectivityMonitor = FlutterConnectivityMonitor();

  ref.onDispose(client.close);

  return client;
}

/// Provides the [SessionManager] for authentication state.
///
/// Screens can watch this provider to react to sign-in / sign-out events.
@Riverpod(keepAlive: true)
SessionManager sessionManager(SessionManagerRef ref) {
  return SessionManager(caller: FlutterConnectivityMonitor());
}
