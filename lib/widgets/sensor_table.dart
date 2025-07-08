import 'package:flutter/material.dart';

class SensorTable extends StatelessWidget {
  const SensorTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Waktu')),
          DataColumn(label: Text('pH Air')),
          DataColumn(label: Text('Suhu Air')),
          DataColumn(label: Text('TDS')),
          DataColumn(label: Text('Water Air')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text("2025-07-07 20:40:20")),
            DataCell(Text("12")),
            DataCell(Text("29")),
            DataCell(Text("380")),
            DataCell(Text("95")),
          ]),
          DataRow(cells: [
            DataCell(Text("2025-07-07 20:40:20")),
            DataCell(Text("9")),
            DataCell(Text("28")),
            DataCell(Text("385")),
            DataCell(Text("90")),
          ]),
          DataRow(cells: [
            DataCell(Text("2025-07-07 20:40:20")),
            DataCell(Text("8.5")),
            DataCell(Text("27.9")),
            DataCell(Text("370")),
            DataCell(Text("80")),
          ]),
          DataRow(cells: [
            DataCell(Text("2025-07-07 20:40:20")),
            DataCell(Text("7.7")),
            DataCell(Text("26")),
            DataCell(Text("375")),
            DataCell(Text("70")),
          ]),
          DataRow(cells: [
            DataCell(Text("2025-07-07 20:40:20")),
            DataCell(Text("7")),
            DataCell(Text("25.5")),
            DataCell(Text("360")),
            DataCell(Text("73")),
          ]),
        ],
      ),
    );
  }
}
