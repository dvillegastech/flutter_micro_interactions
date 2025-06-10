import 'package:flutter/material.dart';

/// A widget that creates a parallax scrolling effect.
class ParallaxScroll extends StatefulWidget {
  /// Creates a parallax scroll widget.
  const ParallaxScroll({
    super.key,
    required this.background,
    required this.foreground,
    this.parallaxFactor = 0.5,
    this.height = 300.0,
    required this.child,
  });

  /// The background widget that moves with parallax effect.
  final Widget background;

  /// The foreground content.
  final Widget foreground;

  /// The parallax factor (0.0 = no parallax, 1.0 = full parallax).
  final double parallaxFactor;

  /// Height of the parallax container.
  final double height;

  /// The child widget to be scrolled.
  final Widget child;

  @override
  State<ParallaxScroll> createState() => _ParallaxScrollState();
}

class _ParallaxScrollState extends State<ParallaxScroll> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Background with parallax effect
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, _scrollOffset * widget.parallaxFactor),
              child: widget.background,
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            controller: _scrollController,
            child: widget.foreground,
          ),
        ],
      ),
    );
  }
}

/// A widget that creates a parallax effect for images.
class ParallaxImage extends StatelessWidget {
  /// Creates a parallax image widget.
  const ParallaxImage({
    super.key,
    required this.imageProvider,
    this.parallaxFactor = 0.3,
    this.height = 200.0,
    this.fit = BoxFit.cover,
  });

  /// The image to display.
  final ImageProvider imageProvider;

  /// The parallax factor.
  final double parallaxFactor;

  /// Height of the image container.
  final double height;

  /// How the image should fit in the container.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              return false;
            },
            child: SingleChildScrollView(
              child: Transform.translate(
                offset: Offset(0, -height * parallaxFactor),
                child: Container(
                  height: height * (1 + parallaxFactor * 2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: fit,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A widget that creates a parallax container with multiple layers.
class ParallaxContainer extends StatefulWidget {
  /// Creates a parallax container widget.
  const ParallaxContainer({
    super.key,
    required this.layers,
    required this.child,
    this.height = 300.0,
  });

  /// List of parallax layers.
  final List<ParallaxLayer> layers;

  /// The main content.
  final Widget child;

  /// Height of the container.
  final double height;

  @override
  State<ParallaxContainer> createState() => _ParallaxContainerState();
}

class _ParallaxContainerState extends State<ParallaxContainer> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Parallax layers
          ...widget.layers.map((layer) {
            return Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, _scrollOffset * layer.parallaxFactor),
                child: layer.child,
              ),
            );
          }),
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Represents a parallax layer.
class ParallaxLayer {
  /// Creates a parallax layer.
  const ParallaxLayer({
    required this.child,
    required this.parallaxFactor,
  });

  /// The widget for this layer.
  final Widget child;

  /// The parallax factor for this layer.
  final double parallaxFactor;
}