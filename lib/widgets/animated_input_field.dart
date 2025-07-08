import 'package:flutter/material.dart';

class AnimatedInputField extends StatefulWidget {
  final String label;
  final TextStyle style;
  final InputDecoration decoration;

  const AnimatedInputField({
    super.key,
    required this.label,
    required this.style,
    required this.decoration,
  });

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: widget.style),
              const SizedBox(height: 4),
              TextField(decoration: widget.decoration),
            ],
          ),
        ),
      ),
    );
  }
}
