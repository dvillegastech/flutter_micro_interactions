import 'package:flutter/material.dart';

/// A widget that provides a glow effect on hover for desktop/web platforms.
class HoverGlow extends StatefulWidget {
  /// Creates a hover glow widget.
  const HoverGlow({
    super.key,
    required this.child,
    this.glowColor,
    this.glowRadius = 12.0,
    this.duration = const Duration(milliseconds: 200),
  });

  /// The child widget to apply the glow effect to.
  final Widget child;

  /// The color of the glow effect.
  final Color? glowColor;

  /// The radius of the glow effect.
  final double glowRadius;

  /// The duration of the glow animation.
  final Duration duration;

  @override
  State<HoverGlow> createState() => _HoverGlowState();
}

class _HoverGlowState extends State<HoverGlow> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverChanged(true),
      onExit: (_) => _handleHoverChanged(false),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.glowRadius),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: (widget.glowColor ?? Theme.of(context).primaryColor)
                            .withValues(alpha: 0.5 * _animation.value),
                        blurRadius: widget.glowRadius * _animation.value,
                        spreadRadius: widget.glowRadius * 0.8 * _animation.value,
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}