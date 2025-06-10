import 'package:flutter/material.dart';

/// Types of page transitions.
enum PageTransitionType {
  /// Fade transition.
  fade,
  
  /// Slide transition from right.
  slideRight,
  
  /// Slide transition from left.
  slideLeft,
  
  /// Slide transition from top.
  slideTop,
  
  /// Slide transition from bottom.
  slideBottom,
  
  /// Scale transition.
  scale,
  
  /// Rotate transition.
  rotate,
  
  /// Size transition.
  size,
  
  /// Flip transition.
  flip,
  
  /// Blur transition.
  blur,
}

/// A page route that provides custom transitions.
class PageTransition<T> extends PageRoute<T> {
  /// Creates a page transition.
  PageTransition({
    required this.child,
    required this.type,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.alignment,
    this.curve = Curves.easeInOut,
    this.fullscreenDialog = false,
    this.maintainState = true,
  }) : super(
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      
      case PageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case PageTransitionType.slideTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case PageTransitionType.slideBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case PageTransitionType.scale:
        return ScaleTransition(
          scale: animation,
          alignment: alignment ?? Alignment.center,
          child: child,
        );
      
      case PageTransitionType.rotate:
        return RotationTransition(
          turns: animation,
          alignment: alignment ?? Alignment.center,
          child: child,
        );
      
      case PageTransitionType.size:
        return Align(
          alignment: alignment ?? Alignment.center,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      
      case PageTransitionType.flip:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
          ),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      
      case PageTransitionType.blur:
        // Note: Blur transition requires a shader mask which is not
        // implemented here for simplicity. In a real implementation,
        // you would use a BackdropFilter with an ImageFilter.blur.
        return FadeTransition(
          opacity: animation,
          child: child,
        );
    }
  }

  /// The child widget to display.
  final Widget child;

  /// The type of transition to use.
  final PageTransitionType type;

  /// Duration of the transition.
  final Duration duration;

  /// Duration of the reverse transition.
  final Duration reverseDuration;

  /// Alignment for scale and rotate transitions.
  final Alignment? alignment;

  /// Animation curve.
  final Curve curve;

  /// Whether this is a fullscreen dialog.
  final bool fullscreenDialog;

  /// Whether to maintain the state of the page when it's not visible.
  final bool maintainState;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => reverseDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;
}

/// A widget that provides a custom transition when navigating to a new page.
class TransitionRoute extends StatelessWidget {
  /// Creates a transition route widget.
  const TransitionRoute({
    super.key,
    required this.builder,
    required this.transitionType,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  /// Builder function for the page content.
  final WidgetBuilder builder;

  /// The type of transition to use.
  final PageTransitionType transitionType;

  /// Duration of the transition.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  /// Navigate to this route.
  Future<T?> push<T>(BuildContext context) {
    return Navigator.of(context).push<T>(
      PageTransition(
        type: transitionType,
        duration: duration,
        curve: curve,
        child: this,
      ),
    );
  }

  /// Replace the current route with this route.
  Future<T?> pushReplacement<T, TO>(BuildContext context, {TO? result}) {
    return Navigator.of(context).pushReplacement<T, TO>(
      PageTransition(
        type: transitionType,
        duration: duration,
        curve: curve,
        child: this,
      ),
      result: result,
    );
  }

  /// Push this route and remove all previous routes.
  Future<T?> pushAndRemoveUntil<T>(BuildContext context, RoutePredicate predicate) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          switch (transitionType) {
            case PageTransitionType.fade:
              return FadeTransition(opacity: curvedAnimation, child: child);
            case PageTransitionType.slideRight:
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );
            // Add other transition cases as needed
            default:
              return child;
          }
        },
        transitionDuration: duration,
      ),
      predicate,
    );
  }
}

/// A widget that provides a hero animation between pages.
class HeroTransition extends StatelessWidget {
  /// Creates a hero transition widget.
  const HeroTransition({
    super.key,
    required this.tag,
    required this.child,
    this.placeholderBuilder,
    this.flightShuttleBuilder,
    this.createRectTween,
  });

  /// The hero tag.
  final String tag;

  /// The child widget.
  final Widget child;

  /// Builder for the placeholder widget.
  final Widget Function(BuildContext, Size, Widget)? placeholderBuilder;

  /// Builder for the flight shuttle widget.
  final Widget Function(BuildContext, Animation<double>, HeroFlightDirection, BuildContext, BuildContext)? flightShuttleBuilder;

  /// Function to create a rect tween.
  final Tween<Rect?> Function(Rect?, Rect?)? createRectTween;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      placeholderBuilder: placeholderBuilder,
      flightShuttleBuilder: flightShuttleBuilder,
      createRectTween: createRectTween,
      child: child,
    );
  }
}

/// A widget that provides a shared axis transition.
class SharedAxisTransition extends StatelessWidget {
  /// Creates a shared axis transition widget.
  const SharedAxisTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    this.axis = Axis.horizontal,
  });

  /// The animation controller.
  final Animation<double> animation;

  /// The secondary animation controller.
  final Animation<double> secondaryAnimation;

  /// The child widget.
  final Widget child;

  /// The axis of the transition.
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    Animation<Offset> slideAnimation;
    if (axis == Axis.horizontal) {
      slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
    } else {
      slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
    }

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}