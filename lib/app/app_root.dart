import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/cubits/auth/auth_cubit.dart';
import '../application/cubits/dashboard/dashboard_cubit.dart';
import '../application/cubits/mqtt/mqtt_cubit.dart';
import '../application/cubits/profile/profile_cubit.dart';
import '../core/repositories/auth_repository.dart';
import '../core/services/connectivity_notifier.dart';
import '../core/services/mqtt_sensor_controller.dart';
import 'bootstrap.dart';
import 'offroad_app.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({
    required this.authRepository,
    required this.connectivityNotifier,
    required this.mqttController,
    required this.bootstrapFuture,
    super.key,
  });

  final AuthRepository authRepository;
  final ConnectivityNotifier connectivityNotifier;
  final MqttSensorController mqttController;
  final Future<BootstrapData> bootstrapFuture;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ConnectivityNotifier>.value(
            value: connectivityNotifier),
        RepositoryProvider<MqttSensorController>.value(value: mqttController),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => AuthCubit(authRepository)),
          BlocProvider<DashboardCubit>(
              create: (_) => DashboardCubit(mqttController)),
          BlocProvider<MqttCubit>(
            create: (_) => MqttCubit(mqttController, connectivityNotifier),
          ),
          BlocProvider<ProfileCubit>(
              create: (_) => ProfileCubit(authRepository)),
        ],
        child: OffroadVehicleMonitoringApp(bootstrapFuture: bootstrapFuture),
      ),
    );
  }
}
