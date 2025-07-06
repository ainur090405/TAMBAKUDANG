import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String label;
  final bool isOn;
  final VoidCallback onToggle;

  const ControlButton({
    super.key,
    required this.label,
    required this.isOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const Spacer(),
        Switch(value: isOn, onChanged: (_) => onToggle()),
      ],
    );
  }
}
