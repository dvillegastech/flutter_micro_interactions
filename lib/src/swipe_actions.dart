import 'package:flutter/material.dart';

/// A widget that provides swipe actions for list items.
class SwipeActions extends StatefulWidget {
  /// Creates a swipe actions widget.
  const SwipeActions({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.actionExtentRatio = 0.25,
    this.dismissThreshold = 0.4,
  });

  /// The child widget to wrap with swipe actions.
  final Widget child;

  /// Actions to show when swiping from left to right.
  final List<SwipeAction> leftActions;

  /// Actions to show when swiping from right to left.
  final List<SwipeAction> rightActions;

  /// The ratio of the action extent to the child's width.
  final double actionExtentRatio;

  /// The threshold for dismissing the item.
  final double dismissThreshold;

  @override
  State<SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<SwipeActions> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: _buildActionBackground(widget.leftActions, Alignment.centerLeft),
      secondaryBackground: _buildActionBackground(widget.rightActions, Alignment.centerRight),
      dismissThresholds: {
        DismissDirection.startToEnd: widget.dismissThreshold,
        DismissDirection.endToStart: widget.dismissThreshold,
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && widget.leftActions.isNotEmpty) {
          widget.leftActions.first.onPressed?.call();
        } else if (direction == DismissDirection.endToStart && widget.rightActions.isNotEmpty) {
          widget.rightActions.first.onPressed?.call();
        }
      },
      child: widget.child,
    );
  }

  Widget _buildActionBackground(List<SwipeAction> actions, Alignment alignment) {
    if (actions.isEmpty) return Container();
    
    return Container(
      color: actions.first.backgroundColor,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        actions.first.icon,
        color: actions.first.iconColor,
        size: 24,
      ),
    );
  }
}

/// Represents a swipe action.
class SwipeAction {
  /// Creates a swipe action.
  const SwipeAction({
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.onPressed,
    this.label,
  });

  /// The icon to display for this action.
  final IconData icon;

  /// The background color of this action.
  final Color backgroundColor;

  /// The color of the icon.
  final Color iconColor;

  /// Callback when this action is triggered.
  final VoidCallback? onPressed;

  /// Optional label for this action.
  final String? label;

  /// Creates a delete action.
  static SwipeAction delete({VoidCallback? onPressed}) {
    return SwipeAction(
      icon: Icons.delete,
      backgroundColor: Colors.red,
      onPressed: onPressed,
      label: 'Delete',
    );
  }

  /// Creates an archive action.
  static SwipeAction archive({VoidCallback? onPressed}) {
    return SwipeAction(
      icon: Icons.archive,
      backgroundColor: Colors.orange,
      onPressed: onPressed,
      label: 'Archive',
    );
  }

  /// Creates a favorite action.
  static SwipeAction favorite({VoidCallback? onPressed}) {
    return SwipeAction(
      icon: Icons.favorite,
      backgroundColor: Colors.pink,
      onPressed: onPressed,
      label: 'Favorite',
    );
  }

  /// Creates a share action.
  static SwipeAction share({VoidCallback? onPressed}) {
    return SwipeAction(
      icon: Icons.share,
      backgroundColor: Colors.blue,
      onPressed: onPressed,
      label: 'Share',
    );
  }
}