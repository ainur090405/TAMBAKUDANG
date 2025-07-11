import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataSensorPage extends StatelessWidget {
  const DataSensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Data Sensor"),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      SensorBoxAnimated(
                        title: "pH Air",
                        value: 12,
                        chart: _lineChartData([
                          FlSpot(0, 7),
                          FlSpot(1, 7.7),
                          FlSpot(2, 8.5),
                          FlSpot(3, 9),
                          FlSpot(4, 12),
                        ]),
                        lastUpdate: "2025-07-07 20:40:20",
                      ),
                      SensorBoxAnimated(
                        title: "Suhu Air",
                        value: 29,
                        chart: _lineChartData([
                          FlSpot(0, 25.5),
                          FlSpot(1, 26),
                          FlSpot(2, 27.9),
                          FlSpot(3, 28),
                          FlSpot(4, 29),
                        ]),
                        lastUpdate: "2025-07-07 20:40:20",
                      ),
                      SensorBoxAnimated(
                        title: "TDS",
                        value: 380,
                        chart: _lineChartData([
                          FlSpot(0, 360),
                          FlSpot(1, 375),
                          FlSpot(2, 370),
                          FlSpot(3, 385),
                          FlSpot(4, 380),
                        ]),
                        lastUpdate: "2025-07-07 20:40:20",
                      ),
                      SensorBoxAnimated(
                        title: "Water Air",
                        value: 95,
                        chart: _lineChartData([
                          FlSpot(0, 73),
                          FlSpot(1, 70),
                          FlSpot(2, 80),
                          FlSpot(3, 90),
                          FlSpot(4, 95),
                        ]),
                        lastUpdate: "2025-07-07 20:40:20",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle("Data Sensor"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            WidgetStateProperty.all(Colors.blue),
                        columns: const [
                          DataColumn(label: Text("Waktu")),
                          DataColumn(label: Text("pH Air")),
                          DataColumn(label: Text("Suhu Air")),
                          DataColumn(label: Text("TDS")),
                          DataColumn(label: Text("Water Air")),
                        ],
                        rows: [
                          _dataRow("2025-07-07 20:40:20", 12, 29, 380, 95),
                          _dataRow("2025-07-07 20:40:20", 9, 28, 385, 90),
                          _dataRow("2025-07-07 20:40:20", 8.5, 27.9, 370, 80),
                          _dataRow("2025-07-07 20:40:20", 7.7, 26, 375, 70),
                          _dataRow("2025-07-07 20:40:20", 7, 25.5, 360, 73),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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

  LineChart _lineChartData(List<FlSpot> spots) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.lightBlue,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            barWidth: 2,
          ),
        ],
      ),
    );
  }

  DataRow _dataRow(String waktu, num ph, num suhu, num tds, num water) {
    return DataRow(
      cells: [
        DataCell(Text(waktu)),
        DataCell(Text(ph.toString())),
        DataCell(Text(suhu.toString())),
        DataCell(Text(tds.toString())),
        DataCell(Text(water.toString())),
      ],
    );
  }
}

class SensorBoxAnimated extends StatefulWidget {
  final String title;
  final num value;
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
  State<SensorBoxAnimated> createState() => _SensorBoxAnimatedState();
}

class _SensorBoxAnimatedState extends State<SensorBoxAnimated> {
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
