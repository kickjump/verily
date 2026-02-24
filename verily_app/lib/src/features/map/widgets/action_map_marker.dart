import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_client/verily_client.dart' as api;
import 'package:verily_ui/verily_ui.dart';

/// A teal circular pin that represents an action on the map.
///
/// Tapping it triggers [onTap], which typically opens the bottom sheet.
class ActionMapMarker extends HookWidget {
  const ActionMapMarker({required this.action, required this.onTap, super.key});

  final api.Action action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: ColorTokens.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.place, color: Colors.white, size: 20),
      ),
    );
  }
}
