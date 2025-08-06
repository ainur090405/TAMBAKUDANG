import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Responsive Sensor Cards
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: const [
                  SensorCard(title: "pH Air", value: "9", unit: "Netral"),
                  SensorCard(title: "Suhu Air", value: "28.5", unit: "°C"),
                  SensorCard(title: "TDS", value: "450", unit: "ppm"),
                  SensorCard(title: "Water Level", value: "95", unit: "%"),
                ],
              ),
              const SizedBox(height: 24),

              const Center(child: ControlToggle(title: "Pompa Air")),
              const SizedBox(height: 32),

              _sectionTitle("Grafik Tren Sensor (7 Hari Terakhir)"),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) =>
                                Text(value.toInt().toString()),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              const labels = ['1', '2', '3', '4', '5'];
                              return Text("Hari ${labels[value.toInt() - 1]}",
                                  style: const TextStyle(fontSize: 10));
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: false,
                          color: Colors.cyan,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                          spots: const [
                            FlSpot(1, 23),
                            FlSpot(2, 30),
                            FlSpot(3, 45),
                            FlSpot(4, 50),
                            FlSpot(5, 95),
                          ],
                        ),
                        LineChartBarData(
                          isCurved: false,
                          color: Colors.lightBlue,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                          spots: const [
                            FlSpot(1, 15),
                            FlSpot(2, 20),
                            FlSpot(3, 28),
                            FlSpot(4, 45),
                            FlSpot(5, 55),
                          ],
                        ),
                        LineChartBarData(
                          isCurved: false,
                          color: Colors.blue,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                          spots: const [
                            FlSpot(1, 10),
                            FlSpot(2, 18),
                            FlSpot(3, 40),
                            FlSpot(4, 35),
                            FlSpot(5, 50),
                          ],
                        ),
                        LineChartBarData(
                          isCurved: false,
                          color: Colors.indigo,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                          spots: const [
                            FlSpot(1, 25),
                            FlSpot(2, 35),
                            FlSpot(3, 50),
                            FlSpot(4, 60),
                            FlSpot(5, 100),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _sectionTitle("Notifikasi"),
              const SizedBox(height: 16),

              // Notifikasi List
              const NotificationCard(
                color: Color(0xFFD6F0FA),
                iconColor: Colors.blue,
                icon: Icons.info,
                message: "TDS (400) dalam batas normal.",
                time: "07/07/2025, 9:24:30 PM - TDS",
              ),
              SizedBox(height: 8),
              const NotificationCard(
                color: Color(0xFFFFF7E5),
                iconColor: Colors.orange,
                icon: Icons.warning,
                message:
                    "pH (6.6) mendekati batas. Batas: 6.5-8.5. Perlu perhatian!",
                time: "07/07/2025, 9:24:30 PM - pH",
              ),
              SizedBox(height: 8),
              const NotificationCard(
                color: Color(0xFFFFE5E5),
                iconColor: Colors.red,
                icon: Icons.error,
                message:
                    "Suhu Air (40) di luar batas. Batas: 39. Segera periksa!",
                time: "07/07/2025, 9:24:30 PM - Suhu Air",
              ),
            ],
          ),
        ),
      ),
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

class SensorCard extends StatefulWidget {
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
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    double progress = double.tryParse(widget.value)! / 100;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 130,
          height: 130,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress > 1 ? 1 : progress,
                    strokeWidth: 8,
                    color: Colors.cyan,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(widget.value,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.unit,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlToggle extends StatefulWidget {
  final String title;
  const ControlToggle({super.key, required this.title});

  @override
  State<ControlToggle> createState() => _ControlToggleState();
}

class _ControlToggleState extends State<ControlToggle> {
  bool isOn = false;
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: (details) {
            _onTapUp(details);
            setState(() => isOn = !isOn);
          },
          onTapCancel: () => setState(() => _scale = 1.0),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: 120,
              height: 45,
              decoration: BoxDecoration(
                color: isOn ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  isOn ? "ON" : "OFF",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;
  final String message;
  final String time;

  const NotificationCard({
    super.key,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
