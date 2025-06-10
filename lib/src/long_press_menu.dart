import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that shows a context menu on long press.
class LongPressMenu extends StatefulWidget {
  /// Creates a long press menu widget.
  const LongPressMenu({
    super.key,
    required this.child,
    required this.menuItems,
    this.enableHaptics = true,
    this.menuBackgroundColor,
    this.menuElevation = 8.0,
    this.menuBorderRadius = 8.0, required Null Function(dynamic item) onMenuItemSelected,
  });

  /// The child widget to wrap with long press functionality.
  final Widget child;

  /// List of menu items to show.
  final List<MenuItem> menuItems;

  /// Whether to enable haptic feedback.
  final bool enableHaptics;

  /// Background color of the menu.
  final Color? menuBackgroundColor;

  /// Elevation of the menu.
  final double menuElevation;

  /// Border radius of the menu.
  final double menuBorderRadius;

  @override
  State<LongPressMenu> createState() => _LongPressMenuState();
}

class _LongPressMenuState extends State<LongPressMenu> {
  void _showContextMenu(BuildContext context, Offset globalPosition) async {
    if (widget.enableHaptics) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        // Haptic feedback might not be available on all platforms
      }
    }

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    await showMenu<void>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: widget.menuItems.map((item) {
        return PopupMenuItem<void>(
          child: ListTile(
            leading: Icon(item.icon, size: 20),
            title: Text(item.label),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onTap: item.onTap,
        );
      }).toList(),
      elevation: widget.menuElevation,
      color: widget.menuBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.menuBorderRadius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: widget.child,
    );
  }
}

/// Represents a menu item.
class MenuItem {
  /// Creates a menu item.
  const MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  /// The icon for this menu item.
  final IconData icon;

  /// The label for this menu item.
  final String label;

  /// Callback when this menu item is tapped.
  final VoidCallback? onTap;

  /// Creates a copy menu item.
  static MenuItem copy({VoidCallback? onTap}) {
    return MenuItem(
      icon: Icons.copy,
      label: 'Copy',
      onTap: onTap,
    );
  }

  /// Creates a share menu item.
  static MenuItem share({VoidCallback? onTap}) {
    return MenuItem(
      icon: Icons.share,
      label: 'Share',
      onTap: onTap,
    );
  }

  /// Creates a delete menu item.
  static MenuItem delete({VoidCallback? onTap}) {
    return MenuItem(
      icon: Icons.delete,
      label: 'Delete',
      onTap: onTap,
    );
  }

  /// Creates an edit menu item.
  static MenuItem edit({VoidCallback? onTap}) {
    return MenuItem(
      icon: Icons.edit,
      label: 'Edit',
      onTap: onTap,
    );
  }

  /// Creates a favorite menu item.
  static MenuItem favorite({VoidCallback? onTap}) {
    return MenuItem(
      icon: Icons.favorite,
      label: 'Favorite',
      onTap: onTap,
    );
  }
}