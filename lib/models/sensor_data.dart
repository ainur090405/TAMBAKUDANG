class SensorData {
  final String name;
  final String unit;
  final double value;
  bool isActive;

  SensorData({
    required this.name,
    required this.unit,
    required this.value,
    this.isActive = true,
  });
}
