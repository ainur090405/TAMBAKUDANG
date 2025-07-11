import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pw_widgets show TableHelper;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final List<Map<String, String>> sensorData = [
    {'sensor': 'pH', 'checkin': '08:00', 'checkout': '12:00'},
    {'sensor': 'Suhu', 'checkin': '09:00', 'checkout': '13:00'},
    {'sensor': 'Kejernihan', 'checkin': '10:00', 'checkout': '14:00'},
  ];

  String searchQuery = "";

  List<Map<String, String>> get filteredData {
    if (searchQuery.isEmpty) return sensorData;
    return sensorData
        .where((data) =>
            data['sensor']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> exportToCSV() async {
    List<List<String>> rows = [
      ["No", "Data Sensor", "Check-in", "Check-out"]
    ];
    for (int i = 0; i < filteredData.length; i++) {
      rows.add([
        (i + 1).toString(),
        filteredData[i]['sensor']!,
        filteredData[i]['checkin']!,
        filteredData[i]['checkout']!,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/laporan_sensor.csv";
    final file = File(path);
    await file.writeAsString(csv);

    if (!mounted) return; // ✅ perbaikan context async
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV berhasil diekspor ke $path')),
    );
  }

  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw_widgets.TableHelper.fromTextArray(
            headers: ["No", "Data Sensor", "Check-in", "Check-out"],
            data: List.generate(filteredData.length, (i) {
              return [
                (i + 1).toString(),
                filteredData[i]['sensor']!,
                filteredData[i]['checkin']!,
                filteredData[i]['checkout']!,
              ];
            }),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Laporan Data Sensor",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Laporan yang diambil setiap bulan"),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, size: 28),
                      onPressed: () => _showExportDialog(),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Search box
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => searchQuery = val),
                        decoration: InputDecoration(
                          hintText: "Cari",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.search),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Table(
                    border: TableBorder.symmetric(
                      inside: const BorderSide(width: 0.5),
                      outside: const BorderSide(width: 1),
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FixedColumnWidth(60),
                    },
                    children: [
                      // Header row
                      const TableRow(
                        decoration:
                            BoxDecoration(color: Color(0xFFD6F0FF)),
                        children: [
                          TableCell(
                              child: Center(
                                  child: Text("No",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text("Data Sensor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text("Check-in",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text("Check-out",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text("Delete",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      ...filteredData.asMap().entries.map((entry) {
                        int i = entry.key;
                        var row = entry.value;
                        return TableRow(
                          children: [
                            Center(child: Text("${i + 1}")),
                            Center(child: Text(row['sensor']!)),
                            Center(child: Text(row['checkin']!)),
                            Center(child: Text(row['checkout']!)),
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    sensorData.remove(row);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ekspor Data"),
        content: const Text("Pilih format file yang ingin diunduh."),
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
}
