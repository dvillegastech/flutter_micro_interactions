import 'package:flutter/material.dart';

class FloatingLabel extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final InputBorder? border;
  final bool enabled;
  final int? maxLines;
  final int? minLines;

  const FloatingLabel({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.border,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<FloatingLabel> createState() => _FloatingLabelState();
}

class _FloatingLabelState extends State<FloatingLabel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    if (hasFocus || (widget.controller?.text.isNotEmpty ?? false)) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _hasError = error != null;
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: _onFocusChange,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onChanged: (value) {
              _validate(value);
              widget.onChanged?.call(value);
            },
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: widget.border ?? const OutlineInputBorder(),
              errorText: _hasError ? _errorText : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: _hasError
                    ? Theme.of(context).colorScheme.error
                    : _isFocused
                        ? Theme.of(context).colorScheme.primary
                        : null,
              ),
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
              child: Text(_errorText ?? ''),
            ),
          ),
      ],
    );
  }
} 