import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorboxAnimated extends StatefulWidget {
  final String title;
  final num value;
  final LineChart chart;
  final String lastUpdate;

  const SensorboxAnimated({
    super.key,
    required this.title,
    required this.value,
    required this.chart,
    required this.lastUpdate,
  });

  @override
  State<SensorboxAnimated> createState() => _SensorboxAnimatedState();
}

class _SensorboxAnimatedState extends State<SensorboxAnimated> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: SizedBox(
          width: 170,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.title}\nNilai saat ini: ${widget.value}\nUpdate terakhir: ${widget.lastUpdate}",
                  style: const TextStyle(fontSize: 11.5),
                ),
                const SizedBox(height: 8),
                SizedBox(height: 80, child: widget.chart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
