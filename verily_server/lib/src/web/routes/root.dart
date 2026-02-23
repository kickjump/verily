import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Serves a default page at the web root.
class RootRoute extends WidgetRoute {
  @override
  Future<AbstractWidget> build(Session session, HttpRequest request) async {
    return BuiltWithServerpod();
  }
}
