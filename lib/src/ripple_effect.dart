import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that creates a ripple effect when tapped.
class RippleEffect extends StatefulWidget {
  /// Creates a ripple effect widget.
  const RippleEffect({
    super.key,
    required this.child,
    this.rippleColor = Colors.white30,
    this.duration = const Duration(milliseconds: 800),
    this.rippleCount = 3,
    this.rippleRadius = 100.0,
    this.rippleSpreadDuration = const Duration(milliseconds: 200),
    this.onTap,
  });

  /// The child widget.
  final Widget child;

  /// Color of the ripple effect.
  final Color rippleColor;

  /// Duration of the ripple animation.
  final Duration duration;

  /// Number of ripples to show.
  final int rippleCount;

  /// Maximum radius of the ripple.
  final double rippleRadius;

  /// Duration between each ripple spread.
  final Duration rippleSpreadDuration;

  /// Callback when tapped.
  final VoidCallback? onTap;

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _tapPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startRipple(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
      _isAnimating = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _startRipple,
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_isAnimating && _tapPosition != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RipplePainter(
                      center: _tapPosition!,
                      progress: _controller.value,
                      rippleColor: widget.rippleColor,
                      rippleCount: widget.rippleCount,
                      rippleRadius: widget.rippleRadius,
                      rippleSpreadDuration: widget.rippleSpreadDuration,
                      animationDuration: widget.duration,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.center,
    required this.progress,
    required this.rippleColor,
    required this.rippleCount,
    required this.rippleRadius,
    required this.rippleSpreadDuration,
    required this.animationDuration,
  });

  final Offset center;
  final double progress;
  final Color rippleColor;
  final int rippleCount;
  final double rippleRadius;
  final Duration rippleSpreadDuration;
  final Duration animationDuration;

  @override
  void paint(Canvas canvas, Size size) {
    final spreadDurationRatio = rippleSpreadDuration.inMilliseconds /
        animationDuration.inMilliseconds;

    for (int i = 0; i < rippleCount; i++) {
      final rippleProgress = (progress - i * spreadDurationRatio).clamp(0.0, 1.0);
      if (rippleProgress <= 0) continue;

      final radius = rippleRadius * rippleProgress;
      final opacity = (1.0 - rippleProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = rippleColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A button with a ripple effect.
class RippleButton extends StatelessWidget {
  /// Creates a ripple button.
  const RippleButton({
    super.key,
    required this.child,
    required this.onTap,
    this.rippleColor = Colors.white24,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  /// The child widget.
  final Widget child;

  /// Callback when tapped.
  final VoidCallback onTap;

  /// Color of the ripple effect.
  final Color rippleColor;

  /// Background color of the button.
  final Color backgroundColor;

  /// Border radius of the button.
  final double borderRadius;

  /// Padding around the child.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      rippleColor: rippleColor,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A widget that creates a water ripple effect.
class WaterRipple extends StatefulWidget {
  /// Creates a water ripple widget.
  const WaterRipple({
    super.key,
    required this.child,
    this.rippleColor = Colors.blue,
    this.waveCount = 5,
    this.duration = const Duration(seconds: 2),
    this.autoPlay = true,
  });

  /// The child widget.
  final Widget child;

  /// Color of the ripple effect.
  final Color rippleColor;

  /// Number of waves to show.
  final int waveCount;

  /// Duration of the animation.
  final Duration duration;

  /// Whether to automatically play the animation.
  final bool autoPlay;

  @override
  State<WaterRipple> createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    if (widget.autoPlay) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Start the ripple animation.
  void startRipple() {
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  /// Stop the ripple animation.
  void stopRipple() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WaterRipplePainter(
                progress: _controller.value,
                rippleColor: widget.rippleColor,
                waveCount: widget.waveCount,
              ),
              child: widget.child,
            );
          },
        ),
      ],
    );
  }
}

class _WaterRipplePainter extends CustomPainter {
  _WaterRipplePainter({
    required this.progress,
    required this.rippleColor,
    required this.waveCount,
  });

  final double progress;
  final Color rippleColor;
  final int waveCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height) * 0.5;

    for (int i = 0; i < waveCount; i++) {
      final waveProgress = (progress + i / waveCount) % 1.0;
      final radius = maxRadius * waveProgress;
      final opacity = (1.0 - waveProgress).clamp(0.0, 0.5);

      final paint = Paint()
        ..color = rippleColor.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}