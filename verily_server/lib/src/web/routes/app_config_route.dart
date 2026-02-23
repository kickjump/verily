import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// JSON endpoint providing API configuration to Flutter web app.
class AppConfigRoute extends Route {
  AppConfigRoute({required this.apiConfig});

  final ServerConfig apiConfig;

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    final config = {
      'apiHost': apiConfig.publicScheme == 'https'
          ? 'https://${apiConfig.publicHost}:${apiConfig.publicPort}'
          : 'http://${apiConfig.publicHost}:${apiConfig.publicPort}',
    };

    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(config));

    await request.response.close();
    return true;
  }
}
