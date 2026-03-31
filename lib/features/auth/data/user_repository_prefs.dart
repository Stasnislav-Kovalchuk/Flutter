import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';

class SharedPrefsUserRepository implements UserRepository {
  SharedPrefsUserRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _userKey = 'user';
  static const _loggedInKey = 'logged_in';

  @override
  Future<void> register(User user) async {
    await _saveUser(user);
    await _prefs.setBool(_loggedInKey, true);
  }

  @override
  Future<User?> getCurrentUser() async {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) {
      return null;
    }

    final map = jsonDecode(jsonString) as Map<String, dynamic>;

    return User(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final user = await getCurrentUser();
    if (user == null) {
      return false;
    }

    final isMatch =
        user.email.toLowerCase() == email.toLowerCase() && user.password == password;
    if (isMatch) {
      await _prefs.setBool(_loggedInKey, true);
    }

    return isMatch;
  }

  @override
  Future<void> updateUser(User user) async {
    await _saveUser(user);
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_loggedInKey);
  }

  @override
  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> _saveUser(User user) async {
    final map = <String, dynamic>{
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };

    await _prefs.setString(_userKey, jsonEncode(map));
  }
}

