import 'package:flutter/material.dart';

class CardFlip extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Duration duration;
  final bool isFlipped;
  final VoidCallback? onFlip;
  final double perspective;

  const CardFlip({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
    this.isFlipped = false,
    this.onFlip,
    this.perspective = 0.001,
  });

  @override
  State<CardFlip> createState() => _CardFlipState();
}

class _CardFlipState extends State<CardFlip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isFlipped) {
      _controller.value = 1;
      _isFrontVisible = false;
    }
  }

  @override
  void didUpdateWidget(CardFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFrontVisible = !_isFrontVisible;
    widget.onFlip?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final transform = Matrix4.identity()
            ..setEntry(3, 2, widget.perspective)
            ..rotateY(3.14159 * _animation.value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _animation.value < 0.5
                ? Transform(
                    transform: Matrix4.identity()..rotateY(0),
                    alignment: Alignment.center,
                    child: widget.front,
                  )
                : Transform(
                    transform: Matrix4.identity()..rotateY(3.14159),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}

// Extension for easy access to card flip
extension CardFlipExtension on Widget {
  Widget withCardFlip({
    required Widget back,
    Duration duration = const Duration(milliseconds: 500),
    bool isFlipped = false,
    VoidCallback? onFlip,
    double perspective = 0.001,
  }) {
    return CardFlip(
      front: this,
      back: back,
      duration: duration,
      isFlipped: isFlipped,
      onFlip: onFlip,
      perspective: perspective,
    );
  }
} 