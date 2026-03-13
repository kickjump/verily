import 'package:flutter/widgets.dart';
import 'package:verily_core/verily_core.dart';

/// A [NavigatorObserver] that logs route changes via [VLogger].
///
/// Attach this to `GoRouter.observers` so every push, pop, replace, and
/// remove is visible in the application logs.
class NavigationObserver extends NavigatorObserver {
  NavigationObserver() : _log = VLogger('Navigation');

  final VLogger _log;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.info(
      'PUSH ${_routeName(route)} '
      '(from ${_routeName(previousRoute)})',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.info(
      'POP ${_routeName(route)} '
      '(back to ${_routeName(previousRoute)})',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log.info(
      'REPLACE ${_routeName(oldRoute)} '
      'with ${_routeName(newRoute)}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.info(
      'REMOVE ${_routeName(route)} '
      '(previous ${_routeName(previousRoute)})',
    );
  }

  String _routeName(Route<dynamic>? route) {
    return route?.settings.name ?? 'unknown';
  }
}
