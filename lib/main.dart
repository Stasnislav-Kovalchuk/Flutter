import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/repositories/auth_repository.dart';
import 'core/services/connectivity_notifier.dart';
import 'core/services/mqtt_sensor_controller.dart';
import 'data/storage/local_auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/home_screen.dart';

class BootstrapData {
  const BootstrapData({
    required this.isLoggedIn,
    required this.offlineAutologin,
  });

  final bool isLoggedIn;
  final bool offlineAutologin;
}

Future<BootstrapData> _loadBootstrap(AuthRepository authRepository) async {
  final bool loggedIn = await authRepository.isLoggedIn();
  final bool online = await ConnectivityNotifier.checkOnline();
  return BootstrapData(
    isLoggedIn: loggedIn,
    offlineAutologin: loggedIn && !online,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
      accountName: 'offroad_vehicle_monitoring_auth',
    ),
  );
  final AuthRepository authRepository = LocalAuthRepository(prefs, secureStorage);
  final Future<BootstrapData> bootstrapFuture = _loadBootstrap(authRepository);

  runApp(
    AppRoot(
      authRepository: authRepository,
      bootstrapFuture: bootstrapFuture,
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    required this.authRepository,
    required this.bootstrapFuture,
    super.key,
  });

  final AuthRepository authRepository;
  final Future<BootstrapData> bootstrapFuture;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        ChangeNotifierProvider<ConnectivityNotifier>(
          create: (_) => ConnectivityNotifier()..init(),
        ),
        ChangeNotifierProvider<MqttSensorController>(
          create: (_) => MqttSensorController(),
        ),
      ],
      child: OffroadVehicleMonitoringApp(
        bootstrapFuture: bootstrapFuture,
      ),
    );
  }
}

class OffroadVehicleMonitoringApp extends StatelessWidget {
  const OffroadVehicleMonitoringApp({
    required this.bootstrapFuture,
    super.key,
  });

  final Future<BootstrapData> bootstrapFuture;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offroad Vehicle Monitoring',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121218),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181820),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E28),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: _AuthBootstrap(future: bootstrapFuture),
    );
  }
}

class _AuthBootstrap extends StatelessWidget {
  const _AuthBootstrap({required this.future});

  final Future<BootstrapData> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BootstrapData>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<BootstrapData> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF121218),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final BootstrapData data = snapshot.data!;
        if (data.isLoggedIn) {
          return HomeScreen(launchedOffline: data.offlineAutologin);
        }

        return const LoginScreen();
      },
    );
  }
}
