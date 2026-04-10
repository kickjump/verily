import 'package:serverpod/serverpod.dart';

/// Health check endpoint for load balancer probes and monitoring.
///
/// Returns `{"status": "ok", "timestamp": "..."}` when the server is healthy.
/// The ALB is configured to probe `/health` at 30-second intervals.
class HealthRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return JsonWidget(
      object: {
        'status': 'ok',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }
}
