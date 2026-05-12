import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/cubits/mqtt/mqtt_cubit.dart';

const String _kMqttTopic = 'vehicle/motor/temperature';

class MqttCard extends StatelessWidget {
  const MqttCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttCubit, MqttState>(
      builder: (BuildContext context, MqttState state) {
        final String payloadLabel = state.temperature ?? '—';
        final String status = state.statusMessage ?? '—';

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
                const Text(
                  'Топік: $_kMqttTopic\n'
                  'Публікація: mosquitto_pub -h localhost -t '
                  '$_kMqttTopic -m "88.5"\n'
                  '(Android-емулятор: замість localhost — 10.0.2.2)',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Icon(
                      state.isConnected
                          ? Icons.cloud_done
                          : state.isConnecting
                              ? Icons.hourglass_top
                              : Icons.cloud_off,
                      color:
                          state.isConnected ? Colors.greenAccent : Colors.grey,
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
                        onPressed: state.canUseMqtt && !state.isConnecting
                            ? () => context
                                .read<MqttCubit>()
                                .connect(launchedOffline: false)
                            : null,
                        icon: const Icon(Icons.link),
                        label: const Text('Підключити'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: state.isConnected
                            ? context.read<MqttCubit>().disconnect
                            : null,
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
      },
    );
  }
}
