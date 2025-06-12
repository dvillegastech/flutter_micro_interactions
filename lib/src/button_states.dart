import 'package:flutter/material.dart';

/// A widget that provides state transitions for buttons.
class ButtonStates extends StatefulWidget {
  /// Creates a button states widget with the specified transitions.
  const ButtonStates({
    required this.stateKey,
    required this.child,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: stateKey);

  /// The key to access the state.
  final GlobalKey<ButtonStatesState> stateKey;

  /// The child widget to animate.
  final Widget child;

  /// The widget to show during loading state.
  final Widget Function() onLoading;

  /// The widget to show during success state.
  final Widget Function() onSuccess;

  /// The widget to show during error state.
  final Widget Function() onError;

  /// The duration of the transitions.
  final Duration duration;

  /// Creates a button with state transitions.
  static ButtonStates withTransitions({
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onError,
    Duration duration = const Duration(milliseconds: 300),
    required Widget child,
  }) {
    return ButtonStates(
      stateKey: GlobalKey<ButtonStatesState>(),
      onLoading: onLoading,
      onSuccess: onSuccess,
      onError: onError,
      duration: duration,
      child: child,
    );
  }

  /// Sets the button state to loading.
  void setLoading() {
    (stateKey.currentState as ButtonStatesState).setLoading();
  }

  /// Sets the button state to success.
  void setSuccess() {
    (stateKey.currentState as ButtonStatesState).setSuccess();
  }

  /// Sets the button state to error.
  void setError() {
    (stateKey.currentState as ButtonStatesState).setError();
  }

  /// Resets the button state to initial.
  void reset() {
    (stateKey.currentState as ButtonStatesState).reset();
  }

  @override
  State<ButtonStates> createState() => ButtonStatesState();
}

class ButtonStatesState extends State<ButtonStates> with SingleTickerProviderStateMixin {
  ButtonState _currentState = ButtonState.initial;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0, // Start with full visibility
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Sets the button state to loading.
  void setLoading() {
    setState(() {
      _currentState = ButtonState.loading;
    });
    _controller.reset();
    _controller.forward();
  }

  /// Sets the button state to success.
  void setSuccess() {
    setState(() {
      _currentState = ButtonState.success;
    });
    _controller.reset();
    _controller.forward();
  }

  /// Sets the button state to error.
  void setError() {
    setState(() {
      _currentState = ButtonState.error;
    });
    _controller.reset();
    _controller.forward();
  }

  /// Resets the button state to initial.
  void reset() {
    setState(() {
      _currentState = ButtonState.initial;
    });
    _controller.reset();
    _controller.forward();
  }

  Widget _buildStateWidget() {
    switch (_currentState) {
      case ButtonState.initial:
        return widget.child;
      case ButtonState.loading:
      case ButtonState.success:
      case ButtonState.error:
        // For non-initial states, we need to preserve the button structure
        // but replace its content
        if (widget.child is ElevatedButton) {
          final button = widget.child as ElevatedButton;
          Widget stateContent;
          switch (_currentState) {
            case ButtonState.loading:
              stateContent = widget.onLoading();
              break;
            case ButtonState.success:
              stateContent = widget.onSuccess();
              break;
            case ButtonState.error:
              stateContent = widget.onError();
              break;
            default:
              stateContent = button.child ?? const SizedBox();
          }
          return ElevatedButton(
            onPressed: null, // Disable button during state transitions
            style: button.style,
            child: stateContent,
          );
        }
        // Fallback for other widget types
        switch (_currentState) {
          case ButtonState.loading:
            return widget.onLoading();
          case ButtonState.success:
            return widget.onSuccess();
          case ButtonState.error:
            return widget.onError();
          default:
            return widget.child;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_animation.value * 0.1),
          child: Opacity(
            opacity: 0.7 + (_animation.value * 0.3),
            child: child,
          ),
        );
      },
      child: _buildStateWidget(),
    );
  }
}

/// The possible states of a button.
enum ButtonState {
  /// The initial state of the button.
  initial,

  /// The loading state of the button.
  loading,

  /// The success state of the button.
  success,

  /// The error state of the button.
  error,
}

typedef ButtonStatesController = GlobalKey<State<ButtonStates>>;