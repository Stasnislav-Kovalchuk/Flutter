import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/connectivity_notifier.dart';
import '../core/services/mqtt_sensor_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    this.launchedOffline = false,
    super.key,
  });

  final bool launchedOffline;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _controller = TextEditingController();

  String _mode = 'None';
  bool _is4x4 = false;
  bool _lowGear = false;
  bool _diffLock = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryConnectMqtt());
  }

  Future<void> _tryConnectMqtt() async {
    if (!mounted) {
      return;
    }
    if (widget.launchedOffline) {
      return;
    }
    final MqttSensorController mqtt = context.read<MqttSensorController>();
    final bool online = await ConnectivityNotifier.checkOnline();
    if (!mounted) {
      return;
    }
    await mqtt.connectIfPossible(networkAvailable: online);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyMode() {
    final String input = _controller.text.trim().toLowerCase();

    setState(() {
      _error = null;

      if (input == 'sand') {
        _mode = 'Sand';
        _is4x4 = true;
        _lowGear = false;
        _diffLock = false;
      } else if (input == 'mud') {
        _mode = 'Mud';
        _is4x4 = true;
        _lowGear = true;
        _diffLock = true;
      } else if (input == 'snow') {
        _mode = 'Snow';
        _is4x4 = true;
        _lowGear = false;
        _diffLock = false;
      } else if (input == 'mountain') {
        _mode = 'Mountain';
        _is4x4 = true;
        _lowGear = true;
        _diffLock = true;
      } else if (input == '2wd') {
        _mode = 'Eco Mode';
        _is4x4 = false;
        _lowGear = false;
        _diffLock = false;
      } else {
        _error = 'Невідомий режим (sand, mud, snow, mountain)';
      }
    });
  }

  Color get _modeColor {
    switch (_mode) {
      case 'Mud':
        return Colors.brown;
      case 'Sand':
        return Colors.amber;
      case 'Snow':
        return Colors.lightBlue;
      case 'Mountain':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MqttSensorController mqtt = context.watch<MqttSensorController>();
    final ConnectivityNotifier net = context.watch<ConnectivityNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFF111116),
      appBar: AppBar(
        title: const Text('IoT Drive Mode'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A22),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/tire_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.launchedOffline)
                  Card(
                    color: Colors.orange.shade900.withValues(alpha: 0.35),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Офлайн-режим: після з\'явлення мережі MQTT '
                        'підключиться автоматично.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (widget.launchedOffline) const SizedBox(height: 12),
                _buildMqttCard(context, mqtt, net),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Введіть режим: sand / mud / snow / mountain',
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: _error,
                    filled: true,
                    fillColor: const Color(0xFF1E1E28),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _applyMode,
                  child: const Text('Активувати режим'),
                ),
                const SizedBox(height: 30),
                Text(
                  _mode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _modeColor,
                  ),
                ),
                const SizedBox(height: 20),
                _status('4x4 Drive', _is4x4),
                _status('Low Gear', _lowGear),
                _status('Diff Lock', _diffLock),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMqttCard(
    BuildContext context,
    MqttSensorController mqtt,
    ConnectivityNotifier net,
  ) {
    final bool canUseMqtt = !widget.launchedOffline && net.isOnline;
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
                  color: mqtt.isConnected
                      ? Colors.greenAccent
                      : Colors.grey,
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

  Widget _status(String title, bool active) {
    return Card(
      color: const Color(0xFF1A1A22),
      child: ListTile(
        leading: Icon(
          active ? Icons.check_circle : Icons.cancel,
          color: active ? Colors.greenAccent : Colors.redAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          active ? 'ON' : 'OFF',
          style: TextStyle(
            color: active ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
