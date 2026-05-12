import 'package:flutter/foundation.dart';

/// Minimal ChangeNotifier template for very small projects or when
/// you want the simplest possible state-management.
class SimpleCounterModel extends ChangeNotifier {
  int _value = 0;
  bool _loading = false;
  String? _error;

  int get value => _value;
  bool get loading => _loading;
  String? get error => _error;

  void increment() {
    _value++;
    notifyListeners();
  }

  void reset() {
    _value = 0;
    _error = null;
    notifyListeners();
  }

  Future<void> loadInitialValue(Future<int> Function() fetch) async {
    _loading = true;
    notifyListeners();
    try {
      final v = await fetch();
      _value = v;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
