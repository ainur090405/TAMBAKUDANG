import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_provider.dart';
import 'package:intl/intl.dart';

class DataSensorPage extends StatelessWidget {
  const DataSensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttData = Provider.of<MQTTProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Detail Data Sensor"),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  SensorBoxAnimated(
                    title: "pH Air",
                    value: mqttData.phValue,
                    chart: _lineChartData(mqttData.phChartData, Colors.green),
                    lastUpdate: mqttData.logHistory.isEmpty
                        ? '...'
                        : DateFormat('HH:mm:ss')
                            .format(mqttData.logHistory.first.timestamp),
                  ),
                  SensorBoxAnimated(
                    title: "Suhu Air (°C)",
                    value: mqttData.suhuValue,
                    chart: _lineChartData(mqttData.suhuChartData, Colors.orange),
                    lastUpdate: mqttData.logHistory.isEmpty
                        ? '...'
                        : DateFormat('HH:mm:ss')
                            .format(mqttData.logHistory.first.timestamp),
                  ),
                  SensorBoxAnimated(
                    title: "DO (mg/L)", 
                    value: mqttData.doValue,
                    chart: _lineChartData(mqttData.doChartData, Colors.blue),
                    lastUpdate: mqttData.logHistory.isEmpty
                        ? '...'
                        : DateFormat('HH:mm:ss')
                            .format(mqttData.logHistory.first.timestamp),
                  ),
                  SensorBoxAnimated(
                    title: "Water Level (%)",
                    value: mqttData.waterLevelValue,
                    chart: _lineChartData(
                        mqttData.waterLevelChartData, Colors.purple),
                    lastUpdate: mqttData.logHistory.isEmpty
                        ? '...'
                        : DateFormat('HH:mm:ss')
                            .format(mqttData.logHistory.first.timestamp),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle("Tabel Riwayat Data"),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Waktu")),
                      DataColumn(label: Text("pH")),
                      DataColumn(label: Text("Suhu")),
                      DataColumn(label: Text("DO")), // 🔄 ubah label kolom
                      DataColumn(label: Text("Level")),
                    ],
                    rows: mqttData.logHistory
                        .map((log) => DataRow(cells: [
                              DataCell(Text(DateFormat('HH:mm:ss')
                                  .format(log.timestamp))),
                              DataCell(Text(log.ph.toStringAsFixed(1))),
                              DataCell(Text(log.suhu.toStringAsFixed(1))),
                              DataCell(Text(log.doValue.toStringAsFixed(1))), // 🔄 ganti log.do
                              DataCell(
                                  Text(log.waterLevel.toStringAsFixed(0))),
                            ]))
                        .toList(),
                  ),
                ),
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

  LineChart _lineChartData(List<FlSpot> spots, Color color) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots.isNotEmpty ? spots : [const FlSpot(0, 0)],
            isCurved: true,
            color: color,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}

class SensorBoxAnimated extends StatelessWidget {
  final String title;
  final String value;
  final LineChart chart;
  final String lastUpdate;

  const SensorBoxAnimated({
    super.key,
    required this.title,
    required this.value,
    required this.chart,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Update: $lastUpdate",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            SizedBox(height: 60, child: chart),
          ],
        ),
      ),
    );
  }
}
