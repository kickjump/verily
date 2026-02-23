import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:verily_lints/src/rules/disallow_stateful_widgets_rule.dart';
import 'package:verily_lints/src/rules/enforce_pinned_app_dependencies_rule.dart';

final plugin = VerilyPlugin();

class VerilyPlugin extends Plugin {
  @override
  String get name => 'Verily Lints';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(DisallowStatefulWidgetsRule())
      ..registerWarningRule(EnforcePinnedAppDependenciesRule());
  }
}
