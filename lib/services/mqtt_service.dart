import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:logger/logger.dart'; 

typedef SensorDataCallback = void Function(String topic, String message);
final Logger logger = Logger();

class MQTTService {
  final String broker = '31.97.109.174';
  final String username = 'mhs1';
  final String password = 'mhs123';
  final int port = 1883;
  final String clientIdentifier =
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}';

  late MqttServerClient client;
  SensorDataCallback? onDataReceived;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientIdentifier);
    client.port = port;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean();
    client.connectionMessage = connMessage;

    try {
      logger.i('Menghubungkan ke broker MQTT: $broker...');
      final conn = await client.connect(username, password);

      if (conn?.returnCode == MqttConnectReturnCode.connectionAccepted) {
        logger.i('🔌 MQTT Terhubung!');
        client.subscribe('sensor/ph', MqttQos.atLeastOnce);
        client.subscribe('sensor/suhu', MqttQos.atLeastOnce);
        client.subscribe('sensor/do', MqttQos.atLeastOnce); 
        client.subscribe('sensor/water_level', MqttQos.atLeastOnce);

        client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final topic = c[0].topic;
          final payload =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          if (onDataReceived != null) {
            onDataReceived!(topic, payload);
          }
        });
      } else {
        logger.e('❌ Koneksi MQTT ditolak: ${conn?.returnCode}');
        disconnect();
      }
    } catch (e) {
      logger.e('❌ Gagal terhubung ke MQTT: $e');
      disconnect();
    }
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void onConnected() => logger.i('✅ Callback: Terhubung.');
  void onDisconnected() => logger.w('🔌 Callback: Koneksi terputus.');
  void disconnect() => client.disconnect();
}
