import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/connectivity_notifier.dart';

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperatureC,
    required this.windSpeedMps,
    required this.observedAtIso,
  });

  final double temperatureC;
  final double windSpeedMps;
  final String observedAtIso;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'temperatureC': temperatureC,
      'windSpeedMps': windSpeedMps,
      'observedAtIso': observedAtIso,
    };
  }

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) {
    return WeatherSnapshot(
      temperatureC: (json['temperatureC'] as num?)?.toDouble() ?? 0,
      windSpeedMps: (json['windSpeedMps'] as num?)?.toDouble() ?? 0,
      observedAtIso: json['observedAtIso'] as String? ?? '',
    );
  }
}

abstract class WeatherRepository {
  Future<WeatherSnapshot?> getCurrentWeather();
}

class CachedWeatherRepository implements WeatherRepository {
  CachedWeatherRepository(this._dio, this._prefs);

  static const String _cacheKey = 'cached_weather_v1';
  final Dio _dio;
  final SharedPreferences _prefs;

  @override
  Future<WeatherSnapshot?> getCurrentWeather() async {
    final bool online = await ConnectivityNotifier.checkOnline();
    if (!online) {
      return _readCache();
    }

    try {
      const double latitude = 49.8397; // Львів
      const double longitude = 24.0297;
      final WeatherSnapshot w =
          await _fetch(latitude: latitude, longitude: longitude);
      await _writeCache(w);
      return w;
    } catch (_) {
      final WeatherSnapshot? fallback = _readCache();
      if (fallback != null) {
        return fallback;
      }
      rethrow;
    }
  }

  Future<WeatherSnapshot> _fetch({
    required double latitude,
    required double longitude,
  }) async {
    final Response<dynamic> res = await _dio.get<dynamic>(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,wind_speed_10m',
        'timezone': 'auto',
      },
    );

    final dynamic body = res.data;
    if (body is! Map<String, dynamic>) {
      throw Exception('Невірний формат відповіді');
    }
    final dynamic current = body['current'];
    if (current is! Map<String, dynamic>) {
      throw Exception('Немає поля current');
    }

    final double temp = (current['temperature_2m'] as num?)?.toDouble() ?? 0;
    final double windKmh = (current['wind_speed_10m'] as num?)?.toDouble() ?? 0;
    final String time = current['time'] as String? ?? '';

    return WeatherSnapshot(
      temperatureC: temp,
      windSpeedMps: windKmh / 3.6,
      observedAtIso: time,
    );
  }

  Future<void> _writeCache(WeatherSnapshot snapshot) async {
    await _prefs.setString(_cacheKey, jsonEncode(snapshot.toJson()));
  }

  WeatherSnapshot? _readCache() {
    final String? raw = _prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return WeatherSnapshot.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}

