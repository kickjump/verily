import 'package:flutter/widgets.dart';
import 'package:verily_core/verily_core.dart';

/// A [NavigatorObserver] that logs route changes via [VLogger].
///
/// Attach this to `GoRouter.observers` so every push, pop, replace, and
/// remove is visible in the application logs.
class NavigationObserver extends NavigatorObserver {
  NavigationObserver() : _log = VLogger('Navigation');

  final VLogger _log;

  static final RegExp _uuidLikeSegment = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static final RegExp _longHexSegment = RegExp(
    r'^[0-9a-f]{12,}$',
    caseSensitive: false,
  );

  static final RegExp _numericSegment = RegExp(r'^\d{4,}$');

  static final RegExp _base64LikeSegment = RegExp(r'^[A-Za-z0-9_-]{16,}$');

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
    final rawName = route?.settings.name;
    if (rawName == null || rawName.isEmpty) return 'unknown';

    return _normalizeRouteName(rawName);
  }

  String _normalizeRouteName(String routeName) {
    final queryStart = routeName.indexOf('?');
    final withoutQuery = queryStart >= 0
        ? routeName.substring(0, queryStart)
        : routeName;

    final segments = withoutQuery.split('/');
    final normalized = <String>[];

    for (final segment in segments) {
      if (segment.isEmpty) {
        normalized.add(segment);
        continue;
      }

      if (_isSensitiveSegment(segment)) {
        normalized.add(':id');
      } else {
        normalized.add(segment);
      }
    }

    final result = normalized.join('/');
    return result.isEmpty ? '/' : result;
  }

  bool _isSensitiveSegment(String segment) {
    if (_uuidLikeSegment.hasMatch(segment)) return true;
    if (_longHexSegment.hasMatch(segment)) return true;
    if (_numericSegment.hasMatch(segment)) return true;
    if (_base64LikeSegment.hasMatch(segment)) return true;
    return false;
  }
}
