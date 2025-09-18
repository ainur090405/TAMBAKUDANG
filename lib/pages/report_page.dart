import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttData = Provider.of<MQTTProvider>(context, listen: false);

    Future<void> exportToCSV() async {
      List<List<String>> rows = [
        ["Waktu", "pH", "Suhu (°C)", "DO (mg/L)", "Level Air (%)"] 
      ];
      for (var log in mqttData.logHistory) {
        rows.add([
          DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp),
          log.ph.toStringAsFixed(2),
          log.suhu.toStringAsFixed(2),
          log.doValue.toStringAsFixed(2), 
          log.waterLevel.toStringAsFixed(0),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/laporan_sensor.csv";
      final file = File(path);
      await file.writeAsString(csv);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV berhasil diekspor ke $path')),
      );
    }

    Future<void> exportToPDF() async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.TableHelper.fromTextArray(
              headers: ["Waktu", "pH", "Suhu", "DO", "Level"], 
              data: mqttData.logHistory.map((log) {
                return [
                  DateFormat('yy-MM-dd HH:mm').format(log.timestamp),
                  log.ph.toStringAsFixed(2),
                  log.suhu.toStringAsFixed(2),
                  log.doValue.toStringAsFixed(2), 
                  log.waterLevel.toStringAsFixed(0),
                ];
              }).toList(),
            );
          },
        ),
      );
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    }

    void showExportDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ekspor Data"),
          content: const Text("Pilih format file."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                exportToCSV();
              },
              child: const Text("CSV"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                exportToPDF();
              },
              child: const Text("PDF"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      appBar: AppBar(
        title: const Text('Laporan Data Sensor'),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: showExportDialog)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Consumer<MQTTProvider>(
            builder: (context, provider, child) {
              return DataTable(
                columns: const [
                  DataColumn(label: Text("Waktu")),
                  DataColumn(label: Text("pH")),
                  DataColumn(label: Text("Suhu")),
                  DataColumn(label: Text("DO")), 
                  DataColumn(label: Text("Level")),
                ],
                rows: provider.logHistory.map((log) => DataRow(cells: [
                      DataCell(Text(DateFormat('HH:mm:ss').format(log.timestamp))),
                      DataCell(Text(log.ph.toStringAsFixed(1))),
                      DataCell(Text(log.suhu.toStringAsFixed(1))),
                      DataCell(Text(log.doValue.toStringAsFixed(1))), 
                      DataCell(Text(log.waterLevel.toStringAsFixed(0))),
                    ])).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
