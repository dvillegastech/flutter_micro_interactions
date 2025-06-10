import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that displays a loading skeleton with shimmer effect.
class LoadingSkeleton extends StatefulWidget {
  /// Creates a loading skeleton widget.
  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 4.0,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
    this.child,
  });

  /// Width of the skeleton.
  final double width;

  /// Height of the skeleton.
  final double height;

  /// Border radius of the skeleton.
  final double borderRadius;

  /// Base color of the skeleton.
  final Color baseColor;

  /// Highlight color for the shimmer effect.
  final Color highlightColor;

  /// Duration of the shimmer animation.
  final Duration duration;

  /// Whether the skeleton is enabled.
  final bool enabled;

  /// Optional child widget to wrap with skeleton effect.
  final Widget? child;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
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
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LoadingSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled && widget.child != null) {
      return widget.child!;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                math.max(0.0, _animation.value - 0.3),
                math.max(0.0, _animation.value),
                math.min(1.0, _animation.value + 0.3),
              ],
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// A widget that displays a text loading skeleton.
class TextSkeleton extends StatelessWidget {
  /// Creates a text skeleton widget.
  const TextSkeleton({
    super.key,
    this.lines = 1,
    this.lineHeight = 16.0,
    this.lineSpacing = 8.0,
    this.lastLineWidth = 0.7,
    this.enabled = true,
  });

  /// Number of lines to display.
  final int lines;

  /// Height of each line.
  final double lineHeight;

  /// Spacing between lines.
  final double lineSpacing;

  /// Width ratio of the last line (0.0 to 1.0).
  final double lastLineWidth;

  /// Whether the skeleton is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < lines - 1 ? lineSpacing : 0,
          ),
          child: LoadingSkeleton(
            width: isLastLine ? (lastLineWidth * double.infinity) : double.infinity,
            height: lineHeight,
            enabled: enabled,
            child: isLastLine
                ? FractionallySizedBox(
                    widthFactor: lastLineWidth,
                    child: Container(),
                  )
                : null,
          ),
        );
      }),
    );
  }
}

/// A widget that displays a card loading skeleton.
class CardSkeleton extends StatelessWidget {
  /// Creates a card skeleton widget.
  const CardSkeleton({
    super.key,
    this.hasImage = true,
    this.imageHeight = 120.0,
    this.titleLines = 1,
    this.subtitleLines = 2,
    this.padding = const EdgeInsets.all(16.0),
    this.enabled = true,
  });

  /// Whether to show an image skeleton.
  final bool hasImage;

  /// Height of the image skeleton.
  final double imageHeight;

  /// Number of title lines.
  final int titleLines;

  /// Number of subtitle lines.
  final int subtitleLines;

  /// Padding around the content.
  final EdgeInsetsGeometry padding;

  /// Whether the skeleton is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            LoadingSkeleton(
              width: double.infinity,
              height: imageHeight,
              borderRadius: 0,
              enabled: enabled,
            ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSkeleton(
                  lines: titleLines,
                  lineHeight: 20.0,
                  enabled: enabled,
                ),
                const SizedBox(height: 12),
                TextSkeleton(
                  lines: subtitleLines,
                  lineHeight: 14.0,
                  lastLineWidth: 0.6,
                  enabled: enabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a list item loading skeleton.
class ListItemSkeleton extends StatelessWidget {
  /// Creates a list item skeleton widget.
  const ListItemSkeleton({
    super.key,
    this.hasAvatar = true,
    this.avatarSize = 40.0,
    this.titleLines = 1,
    this.subtitleLines = 1,
    this.hasTrailing = false,
    this.padding = const EdgeInsets.all(16.0),
    this.enabled = true,
  });

  /// Whether to show an avatar skeleton.
  final bool hasAvatar;

  /// Size of the avatar skeleton.
  final double avatarSize;

  /// Number of title lines.
  final int titleLines;

  /// Number of subtitle lines.
  final int subtitleLines;

  /// Whether to show a trailing widget skeleton.
  final bool hasTrailing;

  /// Padding around the content.
  final EdgeInsetsGeometry padding;

  /// Whether the skeleton is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (hasAvatar) ...[
            LoadingSkeleton(
              width: avatarSize,
              height: avatarSize,
              borderRadius: avatarSize / 2,
              enabled: enabled,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSkeleton(
                  lines: titleLines,
                  lineHeight: 16.0,
                  enabled: enabled,
                ),
                if (subtitleLines > 0) ...[
                  const SizedBox(height: 8),
                  TextSkeleton(
                    lines: subtitleLines,
                    lineHeight: 12.0,
                    lastLineWidth: 0.8,
                    enabled: enabled,
                  ),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            LoadingSkeleton(
              width: 24,
              height: 24,
              borderRadius: 4,
              enabled: enabled,
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays a grid item loading skeleton.
class GridItemSkeleton extends StatelessWidget {
  /// Creates a grid item skeleton widget.
  const GridItemSkeleton({
    super.key,
    this.imageAspectRatio = 1.0,
    this.titleLines = 1,
    this.subtitleLines = 1,
    this.padding = const EdgeInsets.all(8.0),
    this.enabled = true,
  });

  /// Aspect ratio of the image skeleton.
  final double imageAspectRatio;

  /// Number of title lines.
  final int titleLines;

  /// Number of subtitle lines.
  final int subtitleLines;

  /// Padding around the content.
  final EdgeInsetsGeometry padding;

  /// Whether the skeleton is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageAspectRatio,
            child: LoadingSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 8,
              enabled: enabled,
            ),
          ),
          const SizedBox(height: 8),
          TextSkeleton(
            lines: titleLines,
            lineHeight: 14.0,
            enabled: enabled,
          ),
          if (subtitleLines > 0) ...[
            const SizedBox(height: 4),
            TextSkeleton(
              lines: subtitleLines,
              lineHeight: 12.0,
              lastLineWidth: 0.7,
              enabled: enabled,
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that provides skeleton loading for any widget.
class SkeletonLoader extends StatelessWidget {
  /// Creates a skeleton loader widget.
  const SkeletonLoader({
    super.key,
    required this.loading,
    required this.child,
    required this.skeleton,
  });

  /// Whether to show the skeleton.
  final bool loading;

  /// The actual content widget.
  final Widget child;

  /// The skeleton widget to show while loading.
  final Widget skeleton;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: loading ? skeleton : child,
    );
  }
}