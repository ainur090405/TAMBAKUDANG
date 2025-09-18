import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _minPhController = TextEditingController();
  final _maxPhController = TextEditingController();
  final _minSuhuController = TextEditingController();
  final _maxSuhuController = TextEditingController();
  final _minDoController = TextEditingController();
  final _maxDoController = TextEditingController();

  @override
  void dispose() {
    _minPhController.dispose();
    _maxPhController.dispose();
    _minSuhuController.dispose();
    _maxSuhuController.dispose();
    _minDoController.dispose();
    _maxDoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqttProvider = Provider.of<MQTTProvider>(context, listen: false);

    void _saveSettings() {
      if (_minPhController.text.isNotEmpty) mqttProvider.publish('settings/ph_min', _minPhController.text);
      if (_maxPhController.text.isNotEmpty) mqttProvider.publish('settings/ph_max', _maxPhController.text);
      if (_minSuhuController.text.isNotEmpty) mqttProvider.publish('settings/suhu_min', _minSuhuController.text);
      if (_maxSuhuController.text.isNotEmpty) mqttProvider.publish('settings/suhu_max', _maxSuhuController.text);
      if (_minDoController.text.isNotEmpty) mqttProvider.publish('settings/do_min', _minDoController.text);
      if (_maxDoController.text.isNotEmpty) mqttProvider.publish('settings/do_max', _maxDoController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan berhasil dikirim!')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9DD7FA),
      appBar: AppBar(title: const Text("Pengaturan Batas Sensor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_minPhController, "Minimum pH Air"),
              _buildTextField(_maxPhController, "Maksimum pH Air"),
              const Divider(height: 32),
              _buildTextField(_minSuhuController, "Minimum Suhu Air (°C)"),
              _buildTextField(_maxSuhuController, "Maksimum Suhu Air (°C)"),
              const Divider(height: 32),
              _buildTextField(_minDoController, "Minimum DO (mg/L)"),
              _buildTextField(_maxDoController, "Maksimum DO (mg/L)"),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: const Text("Simpan Pengaturan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
