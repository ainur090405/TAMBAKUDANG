import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/data_sensor_page.dart';
import 'pages/report_page.dart';
import 'pages/setting_page.dart';

void main() {
  runApp(const MonitoringTambakApp());
}

class MonitoringTambakApp extends StatelessWidget {
  const MonitoringTambakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitoring Tambak Udang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    DataSensorPage(),
    ReportPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Navbar atas (Logo + Judul)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo_pens.png',
                  height: 36,
                ),
                const SizedBox(width: 10),
                const Text(
                  'MONITORING TAMBAK UDANG',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),

          // Body utama: Sidebar kiri + konten
          Expanded(
            child: Row(
              children: [
                // Sidebar kiri
                Container(
                  width: 80,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          IconButton(
                            icon: const Icon(Icons.dashboard),
                            onPressed: () => setState(() => _currentIndex = 0),
                          ),
                          const SizedBox(height: 20),
                          IconButton(
                            icon: const Icon(Icons.speed),
                            onPressed: () => setState(() => _currentIndex = 1),
                          ),
                          const SizedBox(height: 20),
                          IconButton(
                            icon: const Icon(Icons.insert_chart),
                            onPressed: () => setState(() => _currentIndex = 2),
                          ),
                          const SizedBox(height: 20),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () => setState(() => _currentIndex = 3),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: IconButton(
                          icon: const Icon(Icons.power_settings_new),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // Konten utama
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
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
