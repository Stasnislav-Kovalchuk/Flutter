import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';
import 'session_token_store.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs, FlutterSecureStorage secureStorage)
      : _tokenStore = SessionTokenStore(_prefs, secureStorage);

  static const String _userKey = 'user';
  static const String _passwordKey = 'password';
  static const String _loggedInKey = 'logged_in';

  final SharedPreferences _prefs;
  final SessionTokenStore _tokenStore;

  /// Міграція зі старих збірок: був лише прапорець у SharedPreferences.
  Future<void> _migrateSessionIfNeeded() async {
    final bool loggedIn = _prefs.getBool(_loggedInKey) ?? false;
    if (!loggedIn) {
      return;
    }
    final String? token = await _tokenStore.read();
    if (token == null || token.isEmpty) {
      await _tokenStore.writeNew();
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
    await _tokenStore.writeNew();
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
    await _tokenStore.writeNew();
  }

  @override
  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
    await _tokenStore.clear();
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
    final String? token = await _tokenStore.read();
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
    await _tokenStore.clear();
  }
}
