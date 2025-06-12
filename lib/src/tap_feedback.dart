import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that provides intuitive tap feedback animations.
/// 
/// TapFeedback wraps any widget and provides visual feedback when tapped.
/// It offers several animation types that feel natural and responsive.
/// 
/// Example usage:
/// ```dart
/// TapFeedback.scale(
///   child: ElevatedButton(
///     onPressed: () => print('Tapped!'),
///     child: Text('Tap me'),
///   ),
/// )
/// ```
class TapFeedback extends StatefulWidget {
  /// Creates a tap feedback widget with custom configuration.
  const TapFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
    this.scaleUp = 1.05,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.opacity = 0.8,
    this.enableScale = true,
    this.enableOpacity = false,
    this.enableHaptics = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// Callback when the widget is tapped.
  final VoidCallback? onTap;

  /// Scale factor when pressed down (should be < 1.0).
  final double scaleDown;

  /// Scale factor for bounce effect (should be > 1.0).
  final double scaleUp;

  /// Duration of the animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Opacity when pressed (if enableOpacity is true).
  final double opacity;

  /// Whether to enable scale animation.
  final bool enableScale;

  /// Whether to enable opacity animation.
  final bool enableOpacity;

  /// Whether to enable haptic feedback.
  final bool enableHaptics;

  /// Creates a scale-down feedback (most common and intuitive).
  /// The widget scales down when pressed, giving immediate visual feedback.
  static Widget scale({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    double scale = 0.95,
    Duration duration = const Duration(milliseconds: 150),
    Curve curve = Curves.easeInOut,
    bool enableHaptics = true,
  }) {
    return TapFeedback(
      key: key,
      onTap: onTap,
      scaleDown: scale,
      duration: duration,
      curve: curve,
      enableScale: true,
      enableOpacity: false,
      enableHaptics: enableHaptics,
      child: child,
    );
  }

  /// Creates a bounce feedback with scale and slight overshoot.
  /// The widget scales down then slightly up, creating a bouncy feel.
  static Widget bounce({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    double scaleDown = 0.95,
    double scaleUp = 1.02,
    Duration duration = const Duration(milliseconds: 200),
    bool enableHaptics = true,
  }) {
    return TapFeedback(
      key: key,
      onTap: onTap,
      scaleDown: scaleDown,
      scaleUp: scaleUp,
      duration: duration,
      curve: Curves.elasticOut,
      enableScale: true,
      enableOpacity: false,
      enableHaptics: enableHaptics,
      child: child,
    );
  }

  /// Creates an opacity feedback.
  /// The widget becomes semi-transparent when pressed.
  static Widget fade({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    double opacity = 0.7,
    Duration duration = const Duration(milliseconds: 150),
    bool enableHaptics = true,
  }) {
    return TapFeedback(
      key: key,
      onTap: onTap,
      opacity: opacity,
      duration: duration,
      curve: Curves.easeInOut,
      enableScale: false,
      enableOpacity: true,
      enableHaptics: enableHaptics,
      child: child,
    );
  }

  /// Creates a combined scale and opacity feedback.
  /// The widget scales down and becomes semi-transparent when pressed.
  static Widget scaleAndOpacity({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    double scale = 0.95,
    double opacity = 0.8,
    Duration duration = const Duration(milliseconds: 150),
    bool enableHaptics = true,
  }) {
    return TapFeedback(
      key: key,
      onTap: onTap,
      scaleDown: scale,
      opacity: opacity,
      duration: duration,
      curve: Curves.easeInOut,
      enableScale: true,
      enableOpacity: true,
      enableHaptics: enableHaptics,
      child: child,
    );
  }

  @override
  State<TapFeedback> createState() => _TapFeedbackState();
}

class _TapFeedbackState extends State<TapFeedback>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _opacityController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize scale controller and animation
    _scaleController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: widget.curve,
    ));
    
    // Initialize opacity controller and animation
    _opacityController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.opacity,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  Future<void> _handleTapDown(TapDownDetails details) async {
    if (_isPressed) return;
    _isPressed = true;
    
    // Trigger haptic feedback if enabled
    if (widget.enableHaptics) {
      try {
        await HapticFeedback.lightImpact();
      } catch (e) {
        // Haptic feedback might not be available on all platforms
      }
    }
    
    // Start animations
    if (widget.enableScale) {
      _scaleController.forward();
    }
    if (widget.enableOpacity) {
      _opacityController.forward();
    }
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    await _resetAnimations();
    
    // Call the onTap callback if provided
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  Future<void> _handleTapCancel() async {
    await _resetAnimations();
  }

  Future<void> _resetAnimations() async {
    if (!_isPressed) return;
    _isPressed = false;
    
    // For bounce effect, first go to scaleUp, then back to 1.0
    if (widget.enableScale && widget.curve == Curves.elasticOut) {
      // Create a temporary animation for the bounce effect
      final bounceController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
      );
      
      final bounceAnimation = Tween<double>(
        begin: widget.scaleDown,
        end: widget.scaleUp,
      ).animate(CurvedAnimation(
        parent: bounceController,
        curve: Curves.easeOut,
      ));
      
      // Update the scale animation to use the bounce animation
      bounceController.addListener(() {
        if (mounted) {
          setState(() {
            _scaleAnimation = AlwaysStoppedAnimation(bounceAnimation.value);
          });
        }
      });
      
      await bounceController.forward();
      bounceController.dispose();
      
      // Then animate back to normal
      await _scaleController.reverse();
    } else {
      // Normal reverse animation
      if (widget.enableScale) {
        _scaleController.reverse();
      }
    }
    
    if (widget.enableOpacity) {
      _opacityController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    
    // Apply scale animation if enabled
    if (widget.enableScale) {
      child = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: child,
      );
    }
    
    // Apply opacity animation if enabled
    if (widget.enableOpacity) {
      child = AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value.clamp(0.0, 1.0),
            child: child,
          );
        },
        child: child,
      );
    }
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// The type of tap animation to use.
enum TapAnimationType {
  /// A pulse animation that scales up and down.
  pulse,

  /// A bounce animation that scales up with an elastic effect.
  bounce,

  /// A shrink animation that scales down when pressed.
  shrink,
}