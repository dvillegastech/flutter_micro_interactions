import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// A widget that detects shake gestures and triggers actions.
class ShakeToAction extends StatefulWidget {
  /// Creates a shake to action widget.
  const ShakeToAction({
    super.key,
    required this.child,
    required this.onShake,
    this.shakeThreshold = 2.5,
    this.shakeDuration = const Duration(milliseconds: 500),
    this.enableHaptics = true,
  });

  /// The child widget.
  final Widget child;

  /// Callback when shake is detected.
  final VoidCallback onShake;

  /// Threshold for shake detection.
  final double shakeThreshold;

  /// Duration to wait between shake detections.
  final Duration shakeDuration;

  /// Whether to enable haptic feedback.
  final bool enableHaptics;

  @override
  State<ShakeToAction> createState() => _ShakeToActionState();
}

class _ShakeToActionState extends State<ShakeToAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  DateTime? _lastShakeTime;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerShake() async {
    final now = DateTime.now();
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!) < widget.shakeDuration) {
      return;
    }

    _lastShakeTime = now;
    _isShaking = true;

    if (widget.enableHaptics) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (e) {
        // Haptic feedback might not be available on all platforms
      }
    }

    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        _isShaking = false;
      });
    });

    widget.onShake();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Simulate shake detection based on pan velocity
        final velocity = details.delta.distance;
        if (velocity > widget.shakeThreshold && !_isShaking) {
          _triggerShake();
        }
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_shakeAnimation.value * math.pi * 4) * 5,
              0,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// A widget that provides shake animation without gesture detection.
class ShakeAnimation extends StatefulWidget {
  /// Creates a shake animation widget.
  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.intensity = 5.0,
    this.trigger,
  });

  /// The child widget to animate.
  final Widget child;

  /// Duration of the shake animation.
  final Duration duration;

  /// Intensity of the shake (distance in pixels).
  final double intensity;

  /// External trigger for the animation.
  final ValueNotifier<bool>? trigger;

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    widget.trigger?.addListener(_onTrigger);
  }

  @override
  void dispose() {
    widget.trigger?.removeListener(_onTrigger);
    _controller.dispose();
    super.dispose();
  }

  void _onTrigger() {
    if (widget.trigger?.value == true) {
      shake();
    }
  }

  /// Manually trigger the shake animation.
  void shake() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_animation.value * math.pi * 8) * widget.intensity,
            0,
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// A button that shakes when pressed with invalid input.
class ShakeButton extends StatefulWidget {
  /// Creates a shake button.
  const ShakeButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onInvalidPress,
    this.isValid = true,
  });

  /// The button content.
  final Widget child;

  /// Callback when button is pressed and valid.
  final VoidCallback? onPressed;

  /// Callback when button is pressed but invalid.
  final VoidCallback? onInvalidPress;

  /// Whether the button state is valid.
  final bool isValid;

  @override
  State<ShakeButton> createState() => _ShakeButtonState();
}

class _ShakeButtonState extends State<ShakeButton> {
  final ValueNotifier<bool> _shakeTrigger = ValueNotifier<bool>(false);

  void _handlePress() {
    if (widget.isValid) {
      widget.onPressed?.call();
    } else {
      _shakeTrigger.value = true;
      _shakeTrigger.value = false;
      widget.onInvalidPress?.call();
    }
  }

  @override
  void dispose() {
    _shakeTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShakeAnimation(
      trigger: _shakeTrigger,
      child: ElevatedButton(
        onPressed: _handlePress,
        child: widget.child,
      ),
    );
  }
}