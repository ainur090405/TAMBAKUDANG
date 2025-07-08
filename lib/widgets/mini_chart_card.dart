import 'package:flutter/material.dart';

class MiniChartCard extends StatelessWidget {
  final String title;
  final String currentValue;

  const MiniChartCard({
    super.key,
    required this.title,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: $currentValue", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              color: Colors.blue[50],
              child: const Center(child: Text("Chart")),
            ),
          ),
        ],
      ),
    );
  }
}
