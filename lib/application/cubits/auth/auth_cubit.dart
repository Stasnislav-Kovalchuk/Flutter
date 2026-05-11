import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/entities/user.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/connectivity_notifier.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final bool online = await ConnectivityNotifier.checkOnline();
    if (!online) {
      emit(const AuthNetworkError('Немає з\'єднання з Інтернетом.'));
      return;
    }

    try {
      await _authRepository.login(email: email, password: password);
      emit(const AuthLoginSuccess());
    } on Object catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    emit(const AuthLoading());

    final bool online = await ConnectivityNotifier.checkOnline();
    if (!online) {
      emit(const AuthNetworkError('Реєстрація недоступна без Інтернету.'));
      return;
    }

    try {
      await _authRepository.register(
        email: email,
        name: name,
        password: password,
      );
      emit(const AuthRegisterSuccess());
    } on Object catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
      emit(const AuthLogoutSuccess());
    } on Object catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthUserLoaded(user));
      }
    } on Object catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
