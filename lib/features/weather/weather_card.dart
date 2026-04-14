import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'weather_repository.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  late Future<WeatherSnapshot?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<WeatherRepository>().getCurrentWeather();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = context.read<WeatherRepository>().getCurrentWeather();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Погода',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<WeatherSnapshot?>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Помилка завантаження: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                  );
                }
                final WeatherSnapshot? w = snapshot.data;
                if (w == null) {
                  return const Text(
                    'Немає даних (ні з мережі, ні з кешу).',
                    style: TextStyle(color: Colors.white70),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Температура: ${w.temperatureC.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Вітер: ${w.windSpeedMps.toStringAsFixed(1)} м/с',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Оновлено: ${w.observedAtIso}',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Оновити'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

