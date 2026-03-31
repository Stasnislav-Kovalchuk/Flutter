import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/user_repository_prefs.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userRepository = SharedPrefsUserRepository(prefs);

  runApp(
    OffroadVehicleMonitoringApp(
      userRepository: userRepository,
    ),
  );
}

class OffroadVehicleMonitoringApp extends StatelessWidget {
  const OffroadVehicleMonitoringApp({
    super.key,
    required this.userRepository,
  });

  final SharedPrefsUserRepository userRepository;

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
      home: FutureBuilder<bool>(
        future: userRepository.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return HomeScreen(userRepository: userRepository);
          }
          return LoginScreen(userRepository: userRepository);
        },
      ),
    );
  }
}

