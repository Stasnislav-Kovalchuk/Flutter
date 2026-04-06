import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs, this._secureStorage);

  static const String _userKey = 'user';
  static const String _passwordKey = 'password';
  static const String _loggedInKey = 'logged_in';
  static const String _sessionTokenKey = 'auth_session_token';
  /// Резерв, якщо Keychain недоступний (симулятор / немає Team / -34018).
  static const String _sessionTokenFallbackKey = 'auth_session_token_fallback';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  String _newSessionToken() {
    final Random r = Random.secure();
    return '${DateTime.now().millisecondsSinceEpoch}_'
        '${r.nextInt(1 << 32)}';
  }

  bool _isKeychainEntitlementIssue(PlatformException e) {
    if (e.code == '-34018') {
      return true;
    }
    final String blob = '${e.code} ${e.message} ${e.details}';
    return blob.contains('34018') ||
        (blob.contains('entitlement') && blob.contains("isn't present"));
  }

  Future<String?> _readSessionToken() async {
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

  Future<void> _writeSessionToken() async {
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

  Future<void> _clearSessionToken() async {
    try {
      await _secureStorage.delete(key: _sessionTokenKey);
    } on PlatformException catch (_) {
      // ігноруємо — токен усе одно прибираємо з prefs
    }
    await _prefs.remove(_sessionTokenFallbackKey);
  }

  /// Міграція зі старих збірок: був лише прапорець у SharedPreferences.
  Future<void> _migrateSessionIfNeeded() async {
    final bool loggedIn = _prefs.getBool(_loggedInKey) ?? false;
    if (!loggedIn) {
      return;
    }
    final String? token = await _readSessionToken();
    if (token == null || token.isEmpty) {
      await _writeSessionToken();
    }
  }

  @override
  Future<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final user = User(email: email, name: name);
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs.setString(_passwordKey, password);
    await _prefs.setBool(_loggedInKey, true);
    await _writeSessionToken();
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final storedUser = await getCurrentUser();
    final storedPassword = _prefs.getString(_passwordKey);

    if (storedUser == null ||
        storedPassword == null ||
        storedUser.email != email ||
        storedPassword != password) {
      throw Exception('Невірна пошта або пароль');
    }

    await _prefs.setBool(_loggedInKey, true);
    await _writeSessionToken();
  }

  @override
  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
    await _clearSessionToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) {
      return null;
    }
    try {
      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final bool flag = _prefs.getBool(_loggedInKey) ?? false;
    if (!flag) {
      return false;
    }
    await _migrateSessionIfNeeded();
    final String? token = await _readSessionToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> updateUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> deleteAccount() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_passwordKey);
    await _prefs.remove(_loggedInKey);
    await _clearSessionToken();
  }
}

