import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/entities/user.dart';
import '../../../core/repositories/auth_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(const ProfileInitial()) {
    loadUser();
  }

  final AuthRepository _authRepository;

  Future<void> loadUser() async {
    emit(const ProfileLoading());
    try {
      final User? user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(const ProfileError('Користувач не знайдений'));
      }
    } on Object catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUser(User user) async {
    emit(const ProfileLoading());
    try {
      await _authRepository.updateUser(user);
      emit(ProfileLoaded(user: user));
      emit(const ProfileSaved());
    } on Object catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const ProfileLoading());
    try {
      await _authRepository.logout();
      emit(const ProfileLoggedOut());
    } on Object catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(const ProfileLoading());
    try {
      await _authRepository.deleteAccount();
      emit(const ProfileDeleted());
    } on Object catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
