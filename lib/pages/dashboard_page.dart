import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MQTTProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFADE0FB),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Dashboard"),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      SensorCard(
                          title: "pH Air", value: provider.phValue, unit: "pH"),
                      SensorCard(
                          title: "Suhu Air",
                          value: provider.suhuValue,
                          unit: "°C"),
                      SensorCard(
                          title: "DO", 
                          value: provider.doValue, // pastikan sudah ada di provider
                          unit: "mg/L"),
                      SensorCard(
                          title: "Water Level",
                          value: provider.waterLevelValue,
                          unit: "%"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ControlToggle(
                      title: "Pompa Air",
                      value: provider.isPumpOn,
                      onChanged: (newValue) {
                        provider.togglePump();
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  _sectionTitle("Grafik Tren Sensor"),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: provider.suhuChartData.isNotEmpty
                                ? provider.suhuChartData
                                : [const FlSpot(0, 0)],
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: provider.phChartData.isNotEmpty
                                ? provider.phChartData
                                : [const FlSpot(0, 0)],
                            isCurved: true,
                            color: Colors.green,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (double.tryParse(value) ?? 0.0) / 100.0;
    return Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress > 1 ? 1.0 : progress,
                  strokeWidth: 8,
                  color: Colors.cyan,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              Column(
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(unit, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlToggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ControlToggle({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            onChanged(!value);
          },
          child: Container(
            width: 120,
            height: 45,
            decoration: BoxDecoration(
              color: value ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                value ? "ON" : "OFF",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
