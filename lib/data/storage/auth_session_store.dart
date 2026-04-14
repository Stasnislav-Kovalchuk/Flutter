import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionStore {
  AuthSessionStore(this._prefs, this._secureStorage);

  static const String _loggedInKey = 'logged_in';
  static const String _sessionTokenKey = 'auth_session_token';
  static const String _sessionTokenFallbackKey = 'auth_session_token_fallback';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  bool get loggedInFlag => _prefs.getBool(_loggedInKey) ?? false;

  Future<void> setLoggedInFlag(bool value) async {
    await _prefs.setBool(_loggedInKey, value);
  }

  String _newSessionToken() {
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

  Future<String?> readToken() async {
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

  Future<void> writeNewToken() async {
    final String token = _newSessionToken();
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

  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _sessionTokenKey);
    } on PlatformException catch (_) {
      // ігноруємо — токен усе одно прибираємо з prefs
    }
    await _prefs.remove(_sessionTokenFallbackKey);
  }

  Future<void> migrateIfNeeded() async {
    if (!loggedInFlag) {
      return;
    }
    final String? token = await readToken();
    if (token == null || token.isEmpty) {
      await writeNewToken();
    }
  }
}

