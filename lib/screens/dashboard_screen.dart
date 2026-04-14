import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/connectivity_notifier.dart';
import '../core/services/mqtt_sensor_controller.dart';
import '../features/weather/weather_card.dart';
import 'widgets/drive_mode_panel.dart';
import 'widgets/mqtt_card.dart';

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
                MqttCard(
                  launchedOffline: widget.launchedOffline,
                  mqtt: mqtt,
                  net: net,
                ),
                const SizedBox(height: 20),
                const DriveModePanel(),
                const SizedBox(height: 20),
                const WeatherCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
