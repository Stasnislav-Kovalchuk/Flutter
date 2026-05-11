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
}
