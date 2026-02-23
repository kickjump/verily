import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// A placeholder video player widget.
///
/// In the full implementation, this wraps `video_player` package.
/// For now, it displays a thumbnail with a play button overlay.
class VVideoPlayer extends HookWidget {
  const VVideoPlayer({
    this.videoUrl,
    this.thumbnailUrl,
    this.aspectRatio = 16 / 9,
    this.onPlay,
    super.key,
  });

  final String? videoUrl;
  final String? thumbnailUrl;
  final double aspectRatio;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusTokens.md),
                child: Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            IconButton.filled(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow_rounded, size: 48),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface.withAlpha(200),
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
