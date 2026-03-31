import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/repositories/auth_repository.dart';
import 'data/storage/local_auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AuthRepository authRepository = LocalAuthRepository(prefs);

  runApp(
    OffroadVehicleMonitoringApp(
      authRepository: authRepository,
    ),
  );
}

class OffroadVehicleMonitoringApp extends StatelessWidget {
  const OffroadVehicleMonitoringApp({
    required this.authRepository,
    super.key,
  });

  final AuthRepository authRepository;

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
      home: FutureBuilder<bool>(
        future: authRepository.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: Color(0xFF121218),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final bool isLoggedIn = snapshot.data ?? false;

          if (isLoggedIn) {
            return HomeScreen(authRepository: authRepository);
          }

          return LoginScreen(authRepository: authRepository);
        },
      ),
    );
  }
}
