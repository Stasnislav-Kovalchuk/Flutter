import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/cubits/dashboard/dashboard_cubit.dart';

class DriveModeStatusList extends StatelessWidget {
  const DriveModeStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        return Column(
          children: <Widget>[
            _status('4x4 Drive', state.is4x4),
            _status('Low Gear', state.lowGear),
            _status('Diff Lock', state.diffLock),
          ],
        );
      },
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
        title: Text(title, style: const TextStyle(color: Colors.white)),
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
