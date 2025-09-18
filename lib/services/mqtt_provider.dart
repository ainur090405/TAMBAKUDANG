import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class SensorLogEntry {
  final DateTime timestamp;
  final double ph;
  final double suhu;
  final double doValue;
  final double waterLevel;

  SensorLogEntry({
    required this.timestamp,
    required this.ph,
    required this.suhu,
    required this.doValue,
    required this.waterLevel,
  });
}

class MQTTProvider with ChangeNotifier {
  final MQTTService _mqttService = MQTTService();
  final List<SensorLogEntry> _logHistory = [];
  
  String _phValue = "0.0";
  String _suhuValue = "0.0";
  String _doValue = "0.0";
  String _waterLevelValue = "0.0";
  bool _isPumpOn = false;
  
  Map<String, double> _currentValues = {};
  String get phValue => _phValue;
  String get suhuValue => _suhuValue;
  String get doValue => _doValue;
  String get waterLevelValue => _waterLevelValue;
  List<SensorLogEntry> get logHistory => _logHistory;
  bool get isPumpOn => _isPumpOn; 

  List<FlSpot> get phChartData => _getChartData((log) => log.ph);
  List<FlSpot> get suhuChartData => _getChartData((log) => log.suhu);
  List<FlSpot> get doChartData => _getChartData((log) => log.doValue);
  List<FlSpot> get waterLevelChartData => _getChartData((log) => log.waterLevel);

  MQTTProvider() {
    _connectAndListen();
  }

  void _connectAndListen() async {
    await _mqttService.connect();
    _mqttService.client.subscribe('stat/pompa', MqttQos.atLeastOnce);

    _mqttService.onDataReceived = (topic, message) {
      if (topic == 'stat/pompa') {
        _isPumpOn = (message == '1'); 
        notifyListeners();
        return; 
      }

      final double value = double.tryParse(message) ?? 0.0;
      final String sensorName = topic.split('/').last;

      switch(sensorName) {
        case 'ph': 
          _phValue = message; 
          break;
        case 'suhu': 
          _suhuValue = message; 
          break;
        case 'do': 
          _doValue = message; 
          break;
        case 'water_level': 
          _waterLevelValue = message; 
          break;
      }
      
      _currentValues[sensorName] = value;
      
      if (_currentValues.length >= 4) {
        final newLog = SensorLogEntry(
          timestamp: DateTime.now(),
          ph: _currentValues['ph'] ?? 0.0,
          suhu: _currentValues['suhu'] ?? 0.0,
          doValue: _currentValues['do'] ?? 0.0,
          waterLevel: _currentValues['water_level'] ?? 0.0,
        );
        _logHistory.insert(0, newLog);
        if (_logHistory.length > 100) _logHistory.removeLast();
        _currentValues = {};
      }
      
      notifyListeners();
    };
  }
  
  void togglePump() {
    _isPumpOn = !_isPumpOn;
    final String message = _isPumpOn ? "1" : "0";
    publish("cmnd/pompa", message);
    
    notifyListeners();
  }

  void publish(String topic, String message) {
    _mqttService.publish(topic, message);
  }

  List<FlSpot> _getChartData(double Function(SensorLogEntry log) getValue) {
    final List<FlSpot> chartData = [];
    for (int i = 0; i < _logHistory.length && i < 20; i++) {
      chartData.add(FlSpot(i.toDouble(), getValue(_logHistory[i])));
    }
    return chartData.reversed.toList();
  }
}
