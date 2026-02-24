import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

/// JSON endpoint providing API configuration to Flutter web app.
class AppConfigRoute extends Route {
  AppConfigRoute({required this.apiConfig});

  final ServerConfig apiConfig;

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    final config = {
      'apiHost': apiConfig.publicScheme == 'https'
          ? 'https://${apiConfig.publicHost}:${apiConfig.publicPort}'
          : 'http://${apiConfig.publicHost}:${apiConfig.publicPort}',
    };

    return Response.ok(
      body: Body.fromString(jsonEncode(config), mimeType: MimeType.json),
    );
  }
}
