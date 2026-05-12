import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubits/dashboard/dashboard_cubit.dart';
import '../../../application/cubits/mqtt/mqtt_cubit.dart';
import 'widgets/drive_mode_input.dart';
import 'widgets/drive_mode_status_list.dart';
import 'widgets/mqtt_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    this.launchedOffline = false,
    super.key,
  });

  final bool launchedOffline;

  @override
  Widget build(BuildContext context) {
    context.read<MqttCubit>().connect(launchedOffline: launchedOffline);

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
            child: Container(color: Colors.black.withValues(alpha: 0.7)),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (launchedOffline) ...[
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
                  const SizedBox(height: 12),
                ],
                const MqttCard(),
                const SizedBox(height: 20),
                const DriveModeInput(),
                const SizedBox(height: 30),
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (BuildContext context, DashboardState state) {
                    return Text(
                      state.mode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _modeColor(state.mode),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const DriveModeStatusList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _modeColor(String mode) {
    switch (mode) {
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
}
