import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_loopback_host.dart';

/// MQTT: локальний Mosquitto або публічний HiveMQ.
///
/// Температуру двигуна публікуєш вручну (число в °C), наприклад:
/// `mosquitto_pub -h localhost -t vehicle/motor/temperature -m "88.5"`.
class MqttSensorController extends ChangeNotifier {
  /// `true` — [mqttLoopbackBroker] (127.0.0.1 / 10.0.2.2 на Android-емуляторі).
  /// `false` — `broker.hivemq.com`.
  static const bool useLocalMosquitto = true;

  static String get broker =>
      useLocalMosquitto ? mqttLoopbackBroker() : 'broker.hivemq.com';

  /// Топік для телеметрії температури двигуна (публікація з терміналу / датчика).
  static const String topic = 'vehicle/motor/temperature';
  static const int port = 1883;

  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSub;

  String? _lastPayload;
  String? _statusMessage;
  bool _connecting = false;
  MqttConnectionState _mqttState = MqttConnectionState.disconnected;

  /// Останнє опубліковане значення температури (payload з топіка [topic]).
  String? get lastPayload => _lastPayload;
  String? get statusMessage => _statusMessage;
  bool get isConnecting => _connecting;
  MqttConnectionState get mqttConnectionState => _mqttState;
  bool get isConnected => _mqttState == MqttConnectionState.connected;

  Future<void> connectIfPossible({required bool networkAvailable}) async {
    if (!networkAvailable) {
      _statusMessage = 'Немає мережі — MQTT недоступний';
      notifyListeners();
      return;
    }
    if (_connecting || isConnected) {
      return;
    }

    _connecting = true;
    _statusMessage = 'Підключення до MQTT…';
    notifyListeners();

    final String clientId =
        'flutter_ovm_${DateTime.now().millisecondsSinceEpoch}_'
        '${Random().nextInt(99999)}';
    final String host = broker;
    final MqttServerClient client = MqttServerClient(host, clientId);
    client.port = port;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = () {
      _mqttState = MqttConnectionState.disconnected;
      _statusMessage = 'Роз\'єднано з брокером';
      notifyListeners();
    };
    client.onConnected = () {
      _mqttState = MqttConnectionState.connected;
      _statusMessage = 'Підключено до $host';
      notifyListeners();
    };

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    try {
      await client.connect();
    } on Object catch (e) {
      _statusMessage = 'Помилка MQTT: $e';
      _connecting = false;
      client.disconnect();
      notifyListeners();
      return;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      _statusMessage = 'Не вдалося підключитися до брокера';
      _connecting = false;
      client.disconnect();
      notifyListeners();
      return;
    }

    _client = client;
    _mqttState = MqttConnectionState.connected;
    client.subscribe(topic, MqttQos.atMostOnce);

    await _updatesSub?.cancel();
    _updatesSub = client.updates?.listen(
      (List<MqttReceivedMessage<MqttMessage>> messages) {
        if (messages.isEmpty) {
          return;
        }
        final MqttPublishMessage recMess =
            messages.first.payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        _lastPayload = payload;
        notifyListeners();
      },
    );

    _connecting = false;
    notifyListeners();
  }

  void disconnect() {
    unawaited(_updatesSub?.cancel());
    _updatesSub = null;
    _client?.disconnect();
    _client = null;
    _mqttState = MqttConnectionState.disconnected;
    _statusMessage = 'MQTT відключено';
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
