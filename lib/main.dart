import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'pages/dashboard_page.dart';
import 'pages/data_sensor_page.dart';
import 'pages/report_page.dart';
import 'pages/setting_page.dart';
import 'services/mqtt_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MQTTProvider(),
      child: const MonitoringTambakApp(),
    ),
  );
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
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.dashboard,
                      color: _currentIndex == 0 ? Colors.blue : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 0),
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.speed,
                      color: _currentIndex == 1 ? Colors.blue : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 1),
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.insert_chart,
                      color: _currentIndex == 2 ? Colors.blue : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 2),
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.settings,
                      color: _currentIndex == 3 ? Colors.blue : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}