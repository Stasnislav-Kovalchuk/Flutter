import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_root.dart';
import 'core/repositories/auth_repository.dart';
import 'data/storage/local_auth_repository.dart';
import 'features/weather/weather_repository.dart';

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
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
    ),
  );
  final WeatherRepository weatherRepository = CachedWeatherRepository(dio, prefs);
  final Future<BootstrapData> bootstrapFuture = loadBootstrap(authRepository);

  runApp(
    AppRoot(
      authRepository: authRepository,
      weatherRepository: weatherRepository,
      bootstrapFuture: bootstrapFuture,
    ),
  );
}
