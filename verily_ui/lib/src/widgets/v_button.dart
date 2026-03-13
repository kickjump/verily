import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// The scale factor applied when a button is pressed down.
const _kBtnPressedScale = 0.95;

/// Duration for the press/release animation.
const _kBtnPressDuration = Duration(milliseconds: 100);

/// Additional shadow blur radius added on hover (desktop/web).
const _kBtnHoverBlurRadius = 8.0;

/// Wraps a button [child] with press scale-down and hover elevation
/// animations using `useAnimationController` from flutter_hooks.
///
/// When [enabled] is `false` (e.g. during loading or when `onPressed` is null)
/// the animations are inert and the widget passes through unchanged.
///
/// [showHoverShadow] controls whether the hover shadow is rendered. Set to
/// `false` for text buttons which are visually minimal.
Widget _animatedButtonWrapper({
  required Widget child,
  required AnimationController pressController,
  required double scaleValue,
  required ValueNotifier<bool> isHovered,
  required bool enabled,
  bool showHoverShadow = true,
}) {
  if (!enabled) return child;

  return MouseRegion(
    onEnter: (_) => isHovered.value = true,
    onExit: (_) => isHovered.value = false,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => pressController.forward(),
      onTapUp: (_) => pressController.reverse(),
      onTapCancel: pressController.reverse,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), // pill shape
          boxShadow: showHoverShadow && isHovered.value
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: _kBtnHoverBlurRadius,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        child: Transform.scale(scale: scaleValue, child: child),
      ),
    ),
  );
}

/// A themed filled button for primary actions.
///
/// When [isLoading] transitions between states, the content crossfades
/// smoothly via [AnimatedSwitcher]. Includes a subtle scale-down on press
/// and elevated shadow on hover (desktop/web).
class VFilledButton extends HookWidget {
  const VFilledButton({
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = !isLoading && onPressed != null;

    final pressController = useAnimationController(
      duration: _kBtnPressDuration,
    );
    final scaleValue = useAnimation(
      Tween<double>(begin: 1, end: _kBtnPressedScale).animate(
        CurvedAnimation(parent: pressController, curve: Curves.easeInOut),
      ),
    );
    final isHovered = useState(false);

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: isLoading
            ? SizedBox(
                key: const ValueKey('loading'),
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onSecondary,
                ),
              )
            : KeyedSubtree(key: const ValueKey('content'), child: child),
      ),
    );

    return _animatedButtonWrapper(
      child: button,
      pressController: pressController,
      scaleValue: scaleValue,
      isHovered: isHovered,
      enabled: enabled,
    );
  }
}

/// A themed outlined button for secondary actions.
///
/// Includes a subtle scale-down on press and elevated shadow on hover
/// (desktop/web).
class VOutlinedButton extends HookWidget {
  const VOutlinedButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    final pressController = useAnimationController(
      duration: _kBtnPressDuration,
    );
    final scaleValue = useAnimation(
      Tween<double>(begin: 1, end: _kBtnPressedScale).animate(
        CurvedAnimation(parent: pressController, curve: Curves.easeInOut),
      ),
    );
    final isHovered = useState(false);

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white.withValues(alpha: 0.64)
            : const Color(0xFF13213C).withValues(alpha: 0.78),
      ),
      child: child,
    );

    return _animatedButtonWrapper(
      child: button,
      pressController: pressController,
      scaleValue: scaleValue,
      isHovered: isHovered,
      enabled: enabled,
    );
  }
}

/// A themed text button for tertiary actions.
///
/// Includes a subtle scale-down on press. No hover shadow since text buttons
/// are visually minimal.
class VTextButton extends HookWidget {
  const VTextButton({required this.onPressed, required this.child, super.key});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    final pressController = useAnimationController(
      duration: _kBtnPressDuration,
    );
    final scaleValue = useAnimation(
      Tween<double>(begin: 1, end: _kBtnPressedScale).animate(
        CurvedAnimation(parent: pressController, curve: Curves.easeInOut),
      ),
    );
    final isHovered = useState(false);

    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: ColorTokens.primary),
      child: child,
    );

    return _animatedButtonWrapper(
      child: button,
      pressController: pressController,
      scaleValue: scaleValue,
      isHovered: isHovered,
      enabled: enabled,
      showHoverShadow: false,
    );
  }
}
