import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';

/// Handles Apple OAuth callbacks for web and Android.
class AppleOauthCallbackRoute extends WidgetRoute {
  AppleOauthCallbackRoute({this.androidPackageIdentifier});

  final String? androidPackageIdentifier;

  @override
  Future<AbstractWidget> build(Session session, HttpRequest request) async {
    return AppleIdpCallbackWidget(
      session: session,
      request: request,
      androidPackageIdentifier: androidPackageIdentifier,
    );
  }
}
