import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';
import 'auth_session_store.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs, this._secureStorage);

  static const String _userKey = 'user';
  static const String _passwordKey = 'password';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  late final AuthSessionStore _session = AuthSessionStore(_prefs, _secureStorage);

  @override
  Future<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final user = User(email: email, name: name);
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs.setString(_passwordKey, password);
    await _session.setLoggedInFlag(true);
    await _session.writeNewToken();
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

    await _session.setLoggedInFlag(true);
    await _session.writeNewToken();
  }

  @override
  Future<void> logout() async {
    await _session.setLoggedInFlag(false);
    await _session.clearToken();
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
    if (!_session.loggedInFlag) {
      return false;
    }
    await _session.migrateIfNeeded();
    final String? token = await _session.readToken();
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
    await _session.setLoggedInFlag(false);
    await _session.clearToken();
  }
}

