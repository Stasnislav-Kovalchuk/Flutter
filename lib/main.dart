import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const LabApp());
}

/// Глобальний стан додатка (користувач + режим приводу)
class AppState extends ChangeNotifier {
  String? userName;
  String? userEmail;

  DrivetrainMode _mode = DrivetrainMode.auto;

  DrivetrainMode get mode => _mode;

  void setUser({String? name, String? email}) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void setMode(DrivetrainMode newMode) {
    if (newMode == _mode) return;
    _mode = newMode;
    notifyListeners();
  }
}

enum DrivetrainMode { twoH, fourH, fourL, auto }

extension DrivetrainModeExt on DrivetrainMode {
  String get label {
    switch (this) {
      case DrivetrainMode.twoH:
        return '2H';
      case DrivetrainMode.fourH:
        return '4H';
      case DrivetrainMode.fourL:
        return '4L';
      case DrivetrainMode.auto:
        return 'AUTO';
    }
  }

  String get description {
    switch (this) {
      case DrivetrainMode.twoH:
        return 'Rear-wheel drive • Road/eco';
      case DrivetrainMode.fourH:
        return '4x4 high range • Light offroad';
      case DrivetrainMode.fourL:
        return '4x4 low range • Rock/mud';
      case DrivetrainMode.auto:
        return 'Automatic torque distribution';
    }
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required Widget child,
  }) : super(notifier: appState, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}

class LabApp extends StatefulWidget {
  const LabApp({super.key});

  @override
  State<LabApp> createState() => _LabAppState();
}

class _LabAppState extends State<LabApp> {
  final AppState _state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _state,
      child: MaterialApp(
        title: 'Offroad Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
