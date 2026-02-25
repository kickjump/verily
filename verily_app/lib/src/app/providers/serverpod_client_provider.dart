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
@Riverpod(keepAlive: true)
Client serverpodClient(Ref ref) {
  final client = Client(_devServerUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  ref.onDispose(client.close);

  return client;
}
