import 'package:flutter/material.dart';

/// A widget that provides pull-to-refresh functionality with customizable animations.
class PullToRefresh extends StatefulWidget {
  /// Creates a pull-to-refresh widget.
  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshIndicatorColor,
    this.backgroundColor,
    this.displacement = 40.0,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
  });

  /// The child widget to wrap with pull-to-refresh functionality.
  final Widget child;

  /// Callback function called when refresh is triggered.
  final Future<void> Function() onRefresh;

  /// Color of the refresh indicator.
  final Color? refreshIndicatorColor;

  /// Background color of the refresh indicator.
  final Color? backgroundColor;

  /// Distance from the top where the refresh indicator appears.
  final double displacement;

  /// Width of the refresh indicator stroke.
  final double strokeWidth;

  /// When the refresh indicator should be triggered.
  final RefreshIndicatorTriggerMode triggerMode;

  @override
  State<PullToRefresh> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: widget.refreshIndicatorColor ?? Theme.of(context).primaryColor,
      backgroundColor: widget.backgroundColor,
      displacement: widget.displacement,
      strokeWidth: widget.strokeWidth,
      triggerMode: widget.triggerMode,
      child: widget.child,
    );
  }
}