import 'package:flutter/material.dart';

import 'bootstrap.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/home_screen.dart';

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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final BootstrapData data = snapshot.data!;
        return data.isLoggedIn
            ? HomeScreen(launchedOffline: data.offlineAutologin)
            : const LoginScreen();
      },
    );
  }
}
