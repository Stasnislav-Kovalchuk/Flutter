import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/cubits/home/home_cubit.dart';
import '../../core/services/connectivity_notifier.dart';
import '../../core/services/mqtt_sensor_controller.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.launchedOffline = false,
    super.key,
  });

  /// Автологін без мережі — показуємо попередження та обмежуємо MQTT.
  final bool launchedOffline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit(
        context.read<ConnectivityNotifier>(),
        context.read<MqttSensorController>(),
      )..init(launchedOffline: launchedOffline),
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (HomeState prev, HomeState next) =>
            prev.snackBarMessage != next.snackBarMessage &&
            next.snackBarMessage != null,
        listener: (BuildContext context, HomeState state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.snackBarMessage!),
              duration: const Duration(seconds: 4),
            ),
          );
          context.read<HomeCubit>().consumeSnackBar();
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
            final List<Widget> pages = <Widget>[
              DashboardScreen(launchedOffline: launchedOffline),
              const ProfileScreen(),
            ];

            return Scaffold(
              body: pages[state.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.currentIndex,
                backgroundColor: const Color(0xFF181820),
                selectedItemColor: Colors.orange,
                unselectedItemColor: Colors.grey,
                onTap: context.read<HomeCubit>().setTab,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Панель',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Профіль',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
