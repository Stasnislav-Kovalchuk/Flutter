part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess();
}

final class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

final class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;
}

final class AuthUserLoaded extends AuthState {
  const AuthUserLoaded(this.user);

  final User user;
}

final class AuthNetworkError extends AuthState {
  const AuthNetworkError(this.message);

  final String message;
}
