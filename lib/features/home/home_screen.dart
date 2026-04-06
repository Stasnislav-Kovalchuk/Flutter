import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/connectivity_notifier.dart';
import '../../core/services/mqtt_sensor_controller.dart';
import '../../screens/dashboard_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.launchedOffline = false,
    super.key,
  });

  /// Автологін без мережі — показуємо попередження та обмежуємо MQTT.
  final bool launchedOffline;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _wasOnline = true;
  bool _offlineWarningShown = false;
  late final ConnectivityNotifier _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = context.read<ConnectivityNotifier>();
    _wasOnline = _connectivity.isOnline;
    _connectivity.addListener(_onConnectivityChanged);

    if (widget.launchedOffline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _offlineWarningShown) {
          return;
        }
        _offlineWarningShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ви увійшли без Інтернету (збережена сесія). '
              'MQTT та оновлення з брокера недоступні, доки не з\'явиться мережа.',
            ),
            duration: Duration(seconds: 6),
          ),
        );
      });
    }
  }

  void _onConnectivityChanged() {
    if (!mounted) {
      return;
    }
    final ConnectivityNotifier c = context.read<ConnectivityNotifier>();
    final MqttSensorController mqtt = context.read<MqttSensorController>();

    if (_wasOnline && !c.isOnline) {
      mqtt.disconnect();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('З\'єднання з Інтернетом втрачено'),
          duration: Duration(seconds: 4),
        ),
      );
    }

    if (!_wasOnline && c.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Мережу відновлено'),
          duration: Duration(seconds: 3),
        ),
      );
      mqtt.connectIfPossible(networkAvailable: true);
    }

    _wasOnline = c.isOnline;
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      DashboardScreen(launchedOffline: widget.launchedOffline),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF181820),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
  }
}
