import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A themed avatar widget that displays a user image or initials.
class VAvatar extends HookWidget {
  const VAvatar({this.imageUrl, this.initials, this.radius = 24, super.key});

  final String? imageUrl;
  final String? initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        initials ?? '?',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
