import '../../core/entities/user.dart';

abstract class AuthRepository {
  Future<void> register({
    required String email,
    required String name,
    required String password,
  });

  Future<void> updateUser(User user);

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteAccount();

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();
}

