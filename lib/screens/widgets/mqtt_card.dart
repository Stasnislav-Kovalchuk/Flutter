import 'package:flutter/material.dart';

import '../../core/services/connectivity_notifier.dart';
import '../../core/services/mqtt_sensor_controller.dart';

class MqttCard extends StatelessWidget {
  const MqttCard({
    required this.launchedOffline,
    required this.mqtt,
    required this.net,
    super.key,
  });

  final bool launchedOffline;
  final MqttSensorController mqtt;
  final ConnectivityNotifier net;

  @override
  Widget build(BuildContext context) {
    final bool canUseMqtt = !launchedOffline && net.isOnline;
    final String payloadLabel = mqtt.lastPayload ?? '—';
    final String status = mqtt.statusMessage ?? '—';

    return Card(
      color: const Color(0xFF1A1A22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Температура двигуна (MQTT)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // ignore: prefer_const_constructors — підпис залежить від MqttSensorController.topic
            Text(
              'Топік: ${MqttSensorController.topic}\n'
              'Публікація: mosquitto_pub -h localhost -t '
              '${MqttSensorController.topic} -m "88.5"\n'
              '(Android-емулятор: замість localhost — 10.0.2.2)',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Icon(
                  mqtt.isConnected
                      ? Icons.cloud_done
                      : mqtt.isConnecting
                          ? Icons.hourglass_top
                          : Icons.cloud_off,
                  color: mqtt.isConnected ? Colors.greenAccent : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Температура: $payloadLabel °C',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canUseMqtt && !mqtt.isConnecting
                        ? () => mqtt.connectIfPossible(
                              networkAvailable: net.isOnline,
                            )
                        : null,
                    icon: const Icon(Icons.link),
                    label: const Text('Підключити'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: mqtt.isConnected ? mqtt.disconnect : null,
                    icon: const Icon(Icons.link_off),
                    label: const Text('Відключити'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

