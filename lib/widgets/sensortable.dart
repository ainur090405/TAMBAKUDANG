import 'package:flutter/material.dart';

class Sensortable extends StatelessWidget {
  const Sensortable
({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade300),
        columns: const [
          DataColumn(label: Text('Waktu')),
          DataColumn(label: Text('pH Air')),
          DataColumn(label: Text('Suhu Air')),
          DataColumn(label: Text('TDS')),
          DataColumn(label: Text('Water Level')),
        ],
        rows: [
          _row("2025-07-07 20:40:20", 12, 29, 380, 95),
          _row("2025-07-07 20:40:20", 9, 28, 385, 90),
          _row("2025-07-07 20:40:20", 8.5, 27.9, 370, 80),
          _row("2025-07-07 20:40:20", 7.7, 26, 375, 70),
          _row("2025-07-07 20:40:20", 7, 25.5, 360, 73),
        ],
      ),
    );
  }

  DataRow _row(String time, num ph, num suhu, num tds, num water) {
    return DataRow(
      cells: [
        DataCell(Text(time)),
        DataCell(Text(ph.toString())),
        DataCell(Text(suhu.toString())),
        DataCell(Text(tds.toString())),
        DataCell(Text(water.toString())),
      ],
    );
  }
}
