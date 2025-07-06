import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../widgets/sensor_card.dart';
import '../widgets/control_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<SensorData> sensorList = [
    SensorData(name: 'pH Air', unit: '', value: 7.2),
    SensorData(name: 'Suhu Air', unit: '°C', value: 28.5),
    SensorData(name: 'Kejernihan', unit: 'NTU', value: 5.0),
    SensorData(name: 'Ketinggian Air', unit: 'cm', value: 120),
  ];

  List<double> phHistory = [8.0, 6.5, 5.3, 9.8, 9.6, 7.5, 6.4];

  void toggleSensor(int index) {
    setState(() {
      sensorList[index].isActive = !sensorList[index].isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello!',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Monitoring Dashboard',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Pantauan Terkini',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(sensorList.length, (index) {
                  final sensor = sensorList[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SensorCard(data: sensor),
                      ControlButton(
                        label: sensor.name,
                        isOn: sensor.isActive,
                        onToggle: () => toggleSensor(index),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Riwayat pemantauan level pH 7 hari terakhir',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: LineChartWidget(data: phHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy chart
class LineChartWidget extends StatelessWidget {
  final List<double> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: LineChartPainter(data),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2;

    final paintPoint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final maxVal = 14.0;
    final spacing = size.width / (data.length - 1);

    for (int i = 0; i < data.length - 1; i++) {
      final p1 = Offset(i * spacing, size.height * (1 - data[i] / maxVal));
      final p2 =
          Offset((i + 1) * spacing, size.height * (1 - data[i + 1] / maxVal));
      canvas.drawLine(p1, p2, paintLine);
      canvas.drawCircle(p1, 4, paintPoint);
    }

    final lastPoint = Offset((data.length - 1) * spacing,
        size.height * (1 - data.last / maxVal));
    canvas.drawCircle(lastPoint, 4, paintPoint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
