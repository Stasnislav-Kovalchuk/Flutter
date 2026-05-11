import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_root.dart';
import 'app/bootstrap.dart';
import 'core/repositories/auth_repository.dart';
import 'core/services/connectivity_notifier.dart';
import 'core/services/mqtt_sensor_controller.dart';
import 'data/storage/local_auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
      accountName: 'offroad_vehicle_monitoring_auth',
    ),
  );

  final AuthRepository authRepository =
      LocalAuthRepository(prefs, secureStorage);
  final ConnectivityNotifier connectivityNotifier = ConnectivityNotifier()
    ..init();
  final MqttSensorController mqttController = MqttSensorController();

  runApp(
    AppRoot(
      authRepository: authRepository,
      connectivityNotifier: connectivityNotifier,
      mqttController: mqttController,
      bootstrapFuture: loadBootstrap(authRepository),
    ),
  );
}
