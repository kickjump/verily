import 'package:serverpod/serverpod.dart';

/// Serves a default page at the web root.
class RootRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return JsonWidget(object: {'name': 'verily', 'status': 'ok'});
  }
}
