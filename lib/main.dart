import 'package:flutter/material.dart';

import 'screens/drive_mode_screen.dart';

void main() {
  runApp(const OffroadVehicleMonitoringApp());
}

class OffroadVehicleMonitoringApp extends StatelessWidget {
  const OffroadVehicleMonitoringApp({super.key});

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
      ),
      home: const DriveModeScreen(),
    );
  }
}

