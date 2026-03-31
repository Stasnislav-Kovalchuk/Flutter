import 'user.dart';

abstract class UserRepository {
  Future<void> register(User user);

  Future<User?> getCurrentUser();

  Future<bool> login({
    required String email,
    required String password,
  });

  Future<void> updateUser(User user);

  Future<void> deleteUser();

  Future<void> logout();
}

