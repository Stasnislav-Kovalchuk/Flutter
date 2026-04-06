import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Слідкує за станом мережі через [connectivity_plus].
class ConnectivityNotifier extends ChangeNotifier {
  ConnectivityNotifier({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  List<ConnectivityResult> _results = <ConnectivityResult>[
    ConnectivityResult.none,
  ];

  bool get isOnline => _results.any(
        (ConnectivityResult r) => r != ConnectivityResult.none,
      );

  Future<void> init() async {
    _results = await _connectivity.checkConnectivity();
    notifyListeners();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _results = results;
        notifyListeners();
      },
    );
  }

  /// Одноразова перевірка (наприклад, перед логіном).
  static Future<bool> checkOnline() async {
    final List<ConnectivityResult> results =
        await Connectivity().checkConnectivity();
    return results.any((ConnectivityResult r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
