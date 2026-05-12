import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionTokenStore {
  SessionTokenStore(this._prefs, this._secureStorage);

  static const String _sessionTokenKey = 'auth_session_token';

  /// Резерв, якщо Keychain недоступний (симулятор / немає Team / -34018).
  static const String _sessionTokenFallbackKey = 'auth_session_token_fallback';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  Future<String?> read() async {
    try {
      final String? fromKeychain =
          await _secureStorage.read(key: _sessionTokenKey);
      if (fromKeychain != null && fromKeychain.isNotEmpty) {
        return fromKeychain;
      }
    } on PlatformException catch (e) {
      if (!_isKeychainEntitlementIssue(e)) {
        rethrow;
      }
    }
    return _prefs.getString(_sessionTokenFallbackKey);
  }

  Future<void> writeNew() async {
    final String token = _newToken();
    try {
      await _secureStorage.write(key: _sessionTokenKey, value: token);
      await _prefs.remove(_sessionTokenFallbackKey);
    } on PlatformException catch (e) {
      if (_isKeychainEntitlementIssue(e)) {
        await _prefs.setString(_sessionTokenFallbackKey, token);
      } else {
        rethrow;
      }
    }
  }

  Future<void> clear() async {
    try {
      await _secureStorage.delete(key: _sessionTokenKey);
    } on PlatformException catch (_) {
      // ігноруємо — токен усе одно прибираємо з prefs
    }
    await _prefs.remove(_sessionTokenFallbackKey);
  }

  String _newToken() {
    final Random r = Random.secure();
    return '${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(1 << 32)}';
  }

  bool _isKeychainEntitlementIssue(PlatformException e) {
    if (e.code == '-34018') {
      return true;
    }
    final String blob = '${e.code} ${e.message} ${e.details}';
    return blob.contains('34018') ||
        (blob.contains('entitlement') && blob.contains("isn't present"));
  }
}
