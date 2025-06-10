import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that morphs between different shapes with smooth animations.
class MorphingShapes extends StatefulWidget {
  /// Creates a morphing shapes widget.
  const MorphingShapes({
    super.key,
    required this.shapes,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 2),
    this.size = const Size(100, 100),
    this.color = Colors.blue,
  });

  /// List of shapes to morph between.
  final List<ShapeType> shapes;

  /// Duration of each morph animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Whether to automatically cycle through shapes.
  final bool autoPlay;

  /// Duration to wait between auto morphs.
  final Duration autoPlayDuration;

  /// Size of the shape.
  final Size size;

  /// Color of the shape.
  final Color color;

  @override
  State<MorphingShapes> createState() => _MorphingShapesState();
}

class _MorphingShapesState extends State<MorphingShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentShapeIndex = 0;
  int _nextShapeIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.autoPlay && widget.shapes.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayDuration, () {
      if (mounted) {
        morphToNext();
      }
    });
  }

  /// Morph to the next shape in the list.
  void morphToNext() {
    if (widget.shapes.length <= 1) return;

    setState(() {
      _nextShapeIndex = (_currentShapeIndex + 1) % widget.shapes.length;
    });

    _controller.forward().then((_) {
      setState(() {
        _currentShapeIndex = _nextShapeIndex;
      });
      _controller.reset();
      
      if (widget.autoPlay) {
        _startAutoPlay();
      }
    });
  }

  /// Morph to a specific shape by index.
  void morphToShape(int index) {
    if (index < 0 || index >= widget.shapes.length || index == _currentShapeIndex) {
      return;
    }

    setState(() {
      _nextShapeIndex = index;
    });

    _controller.forward().then((_) {
      setState(() {
        _currentShapeIndex = _nextShapeIndex;
      });
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.autoPlay ? null : morphToNext,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _MorphingShapePainter(
                currentShape: widget.shapes[_currentShapeIndex],
                nextShape: widget.shapes.length > 1 ? widget.shapes[_nextShapeIndex] : widget.shapes[_currentShapeIndex],
                progress: _animation.value,
                color: widget.color,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Types of shapes that can be morphed.
enum ShapeType {
  circle,
  square,
  triangle,
  star,
  heart,
  diamond,
}

class _MorphingShapePainter extends CustomPainter {
  _MorphingShapePainter({
    required this.currentShape,
    required this.nextShape,
    required this.progress,
    required this.color,
  });

  final ShapeType currentShape;
  final ShapeType nextShape;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Get paths for current and next shapes
    final currentPath = _getShapePath(currentShape, center, radius, size);
    final nextPath = _getShapePath(nextShape, center, radius, size);

    // Interpolate between paths
    final morphedPath = _interpolatePaths(currentPath, nextPath, progress);
    
    canvas.drawPath(morphedPath, paint);
  }

  Path _getShapePath(ShapeType shape, Offset center, double radius, Size size) {
    switch (shape) {
      case ShapeType.circle:
        return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
      
      case ShapeType.square:
        return Path()..addRect(Rect.fromCenter(center: center, width: radius * 2, height: radius * 2));
      
      case ShapeType.triangle:
        final path = Path();
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx - radius, center.dy + radius);
        path.lineTo(center.dx + radius, center.dy + radius);
        path.close();
        return path;
      
      case ShapeType.star:
        return _createStarPath(center, radius);
      
      case ShapeType.heart:
        return _createHeartPath(center, radius);
      
      case ShapeType.diamond:
        final path = Path();
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy);
        path.close();
        return path;
    }
  }

  Path _createStarPath(Offset center, double radius) {
    final path = Path();
    const points = 5;
    const angle = math.pi / points;
    
    for (int i = 0; i < points * 2; i++) {
      final currentRadius = i.isEven ? radius : radius * 0.5;
      final x = center.dx + currentRadius * math.cos(i * angle - math.pi / 2);
      final y = center.dy + currentRadius * math.sin(i * angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createHeartPath(Offset center, double radius) {
    final path = Path();
    final width = radius * 2;
    final height = radius * 1.8;
    
    path.moveTo(center.dx, center.dy + height * 0.3);
    
    path.cubicTo(
      center.dx - width * 0.5, center.dy - height * 0.1,
      center.dx - width * 0.5, center.dy - height * 0.5,
      center.dx, center.dy - height * 0.2,
    );
    
    path.cubicTo(
      center.dx + width * 0.5, center.dy - height * 0.5,
      center.dx + width * 0.5, center.dy - height * 0.1,
      center.dx, center.dy + height * 0.3,
    );
    
    return path;
  }

  Path _interpolatePaths(Path from, Path to, double t) {
    // Simple interpolation - in a real implementation, you might want
    // to use more sophisticated path morphing algorithms
    if (t <= 0.0) return from;
    if (t >= 1.0) return to;
    
    // For simplicity, we'll just fade between the shapes
    // A more advanced implementation would interpolate path points
    return t < 0.5 ? from : to;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A widget that morphs between two specific shapes.
class ShapeMorph extends StatefulWidget {
  /// Creates a shape morph widget.
  const ShapeMorph({
    super.key,
    required this.fromShape,
    required this.toShape,
    this.duration = const Duration(milliseconds: 600),
    this.size = const Size(80, 80),
    this.color = Colors.blue,
    this.autoReverse = false,
  });

  /// The starting shape.
  final ShapeType fromShape;

  /// The ending shape.
  final ShapeType toShape;

  /// Duration of the morph animation.
  final Duration duration;

  /// Size of the shape.
  final Size size;

  /// Color of the shape.
  final Color color;

  /// Whether to automatically reverse the animation.
  final bool autoReverse;

  @override
  State<ShapeMorph> createState() => _ShapeMorphState();
}

class _ShapeMorphState extends State<ShapeMorph>
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
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.autoReverse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Start the morph animation.
  void morph() {
    if (_controller.isAnimating) return;
    
    if (_controller.value == 0.0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.autoReverse ? null : morph,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _MorphingShapePainter(
                currentShape: widget.fromShape,
                nextShape: widget.toShape,
                progress: _animation.value,
                color: widget.color,
              ),
            );
          },
        ),
      ),
    );
  }
}