import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:logger/logger.dart';

typedef SensorDataCallback = void Function(String topic, String message);

final Logger logger = Logger(); // ✅ Optional: bisa diganti print()

class MQTTService {
  final String broker = 'broker.hivemq.com';
  final String clientIdentifier =
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
  final int port = 1883;

  late MqttServerClient client;
  SensorDataCallback? onDataReceived;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientIdentifier);
    client.port = port;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean(); // 🔁 Buat koneksi fresh

    try {
      final conn = await client.connect();
      if (conn?.returnCode == MqttConnectReturnCode.connectionAccepted) {
        logger.i('🔌 MQTT Connected'); // Atau pakai: print('🔌 MQTT Connected');

        // 📡 Subscribe topik
        client.subscribe('sensor/ph', MqttQos.atLeastOnce);
        client.subscribe('sensor/suhu', MqttQos.atLeastOnce);
        client.subscribe('sensor/tds', MqttQos.atLeastOnce);
        client.subscribe('sensor/water_level', MqttQos.atLeastOnce);

        // 📨 Listener data masuk
        client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final topic = c[0].topic;
          final payload = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message);

          logger.d('📨 [$topic] ➝ $payload'); // atau print

          if (onDataReceived != null) {
            onDataReceived!(topic, payload);
          }
        });
      } else {
        logger.e('❌ MQTT Connection rejected: ${conn?.returnCode}');
        disconnect();
      }
    } catch (e) {
      logger.e('❌ MQTT Connection failed: $e');
      disconnect();
    }
  }

  void onConnected() {
    logger.i('✅ MQTT Connected');
  }

  void onDisconnected() {
    logger.w('🔌 MQTT Disconnected');
  }

  void disconnect() {
    client.disconnect();
  }
}
