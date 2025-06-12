import 'package:flutter/material.dart';

class ReorderableList extends StatefulWidget {
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;
  final EdgeInsets? padding;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ReorderableList({
    super.key,
    required this.children,
    required this.onReorder,
    this.padding,
    this.scrollController,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<ReorderableList> createState() => _ReorderableListState();
}

class _ReorderableListState extends State<ReorderableList> {
  int? _draggedIndex;
  int? _targetIndex;
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.children.length; i++) {
      _itemKeys[i] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: widget.padding,
      scrollController: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: widget.children.length,
      onReorderStart: (index) {
        setState(() {
          _draggedIndex = index;
        });
      },
      onReorderEnd: (_) {
        setState(() {
          _draggedIndex = null;
          _targetIndex = null;
        });
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        widget.onReorder(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        return _buildDraggableItem(index);
      },
    );
  }

  Widget _buildDraggableItem(int index) {
    final isDragging = index == _draggedIndex;
    final isTarget = index == _targetIndex;

    return AnimatedContainer(
      key: _itemKeys[index],
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..scale(isDragging ? 1.05 : 1.0),
      decoration: BoxDecoration(
        color: isDragging
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : isTarget
                ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                : null,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.drag_handle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(child: widget.children[index]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension for easy access to reorderable list items
extension ReorderableListExtension on List<Widget> {
  Widget toReorderableList({
    required void Function(int oldIndex, int newIndex) onReorder,
    EdgeInsets? padding,
    ScrollController? scrollController,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ReorderableList(
      children: this,
      onReorder: onReorder,
      padding: padding,
      scrollController: scrollController,
      shrinkWrap: shrinkWrap,
      physics: physics,
    );
  }
} 