import 'package:flutter/material.dart';

/// A widget that provides focus animations for input fields.
class InputFocus extends StatefulWidget {
  /// Creates an input focus widget.
  const InputFocus({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.scale = 1.05,
    this.elevation = 8.0,
  });

  /// The child widget to animate.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The scale factor when focused.
  final double scale;

  /// The elevation when focused.
  final double elevation;

  /// Creates an animated input field.
  static Widget animate({
    Duration duration = const Duration(milliseconds: 200),
    double scale = 1.02,
    double elevation = 4.0,
    required Widget child,
  }) {
    return InputFocus(
      duration: duration,
      scale: scale,
      elevation: elevation,
      child: child,
    );
  }

  @override
  State<InputFocus> createState() => _InputFocusState();
}

class _InputFocusState extends State<InputFocus> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.elevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChanged(bool hasFocus) {
    setState(() {
    });
    if (hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _handleFocusChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              elevation: _elevationAnimation.value,
              borderRadius: BorderRadius.circular(8.0),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}