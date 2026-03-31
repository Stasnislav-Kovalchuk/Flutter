import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._prefs);

  static const String _userKey = 'user';
  static const String _passwordKey = 'password';
  static const String _loggedInKey = 'logged_in';

  final SharedPreferences _prefs;

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
  }

  @override
  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
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
    return _prefs.getBool(_loggedInKey) ?? false;
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
  }
}

