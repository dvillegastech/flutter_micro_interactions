import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A widget that provides elastic scrolling behavior.
class ElasticScroll extends StatefulWidget {
  /// Creates an elastic scroll widget.
  const ElasticScroll({
    super.key,
    required this.child,
    this.elasticity = 0.3,
    this.damping = 0.8,
    this.stiffness = 100.0,
    this.maxOverscroll = 100.0,
    this.scrollDirection = Axis.vertical,
  });

  /// The scrollable child widget.
  final Widget child;

  /// Elasticity factor (0.0 = no elasticity, 1.0 = maximum elasticity).
  final double elasticity;

  /// Damping factor for the elastic effect.
  final double damping;

  /// Stiffness of the elastic spring.
  final double stiffness;

  /// Maximum overscroll distance.
  final double maxOverscroll;

  /// Direction of scrolling.
  final Axis scrollDirection;

  @override
  State<ElasticScroll> createState() => _ElasticScrollState();
}

class _ElasticScrollState extends State<ElasticScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  double _overscroll = 0.0;
  bool _isOverscrolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    
    if (position.pixels < position.minScrollExtent) {
      // Overscroll at the top/left
      final overscroll = position.minScrollExtent - position.pixels;
      _updateOverscroll(-overscroll);
    } else if (position.pixels > position.maxScrollExtent) {
      // Overscroll at the bottom/right
      final overscroll = position.pixels - position.maxScrollExtent;
      _updateOverscroll(overscroll);
    } else {
      _updateOverscroll(0.0);
    }
  }

  void _updateOverscroll(double overscroll) {
    final clampedOverscroll = overscroll.clamp(-widget.maxOverscroll, widget.maxOverscroll);
    
    if (clampedOverscroll != _overscroll) {
      setState(() {
        _overscroll = clampedOverscroll;
        _isOverscrolling = _overscroll.abs() > 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && _isOverscrolling) {
          _snapBack();
        }
        return false;
      },
      child: Transform.translate(
        offset: widget.scrollDirection == Axis.vertical
            ? Offset(0, _overscroll * widget.elasticity)
            : Offset(_overscroll * widget.elasticity, 0),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: widget.scrollDirection,
          physics: const BouncingScrollPhysics(),
          child: widget.child,
        ),
      ),
    );
  }

  void _snapBack() {
    _controller.forward().then((_) {
      setState(() {
        _overscroll = 0.0;
        _isOverscrolling = false;
      });
      _controller.reset();
    });
  }
}

/// A custom scroll physics that provides elastic behavior.
class ElasticScrollPhysics extends ScrollPhysics {
  /// Creates elastic scroll physics.
  const ElasticScrollPhysics({
    super.parent,
    this.elasticity = 0.3,
    this.damping = 0.8,
  });

  /// Elasticity factor.
  final double elasticity;

  /// Damping factor.
  final double damping;

  @override
  ElasticScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ElasticScrollPhysics(
      parent: buildParent(ancestor),
      elasticity: elasticity,
      damping: damping,
    );
  }

  @override
  SpringDescription get spring => SpringDescription(
        mass: 1.0,
        stiffness: 100.0,
        damping: damping * 20.0,
      );

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // Underscroll
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Overscroll
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);
    
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }
      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }
      
      if (end != null) {
        return SpringSimulation(
          spring,
          position.pixels,
          end,
          velocity,
          tolerance: tolerance,
        );
      }
    }
    
    return super.createBallisticSimulation(position, velocity);
  }
}

/// A widget that provides elastic list behavior.
class ElasticListView extends StatelessWidget {
  /// Creates an elastic list view.
  const ElasticListView({
    super.key,
    required this.children,
    this.elasticity = 0.3,
    this.damping = 0.8,
    this.scrollDirection = Axis.vertical,
    this.padding,
  });

  /// List of child widgets.
  final List<Widget> children;

  /// Elasticity factor.
  final double elasticity;

  /// Damping factor.
  final double damping;

  /// Scroll direction.
  final Axis scrollDirection;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: ElasticScrollPhysics(
        elasticity: elasticity,
        damping: damping,
      ),
      children: children,
    );
  }
}

/// A widget that provides elastic grid behavior.
class ElasticGridView extends StatelessWidget {
  /// Creates an elastic grid view.
  const ElasticGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.elasticity = 0.3,
    this.damping = 0.8,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding,
  });

  /// List of child widgets.
  final List<Widget> children;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Elasticity factor.
  final double elasticity;

  /// Damping factor.
  final double damping;

  /// Spacing between columns.
  final double crossAxisSpacing;

  /// Spacing between rows.
  final double mainAxisSpacing;

  /// Aspect ratio of each child.
  final double childAspectRatio;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      physics: ElasticScrollPhysics(
        elasticity: elasticity,
        damping: damping,
      ),
      children: children,
    );
  }
}