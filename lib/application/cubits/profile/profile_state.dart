part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user});

  final User user;
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;
}

final class ProfileSaved extends ProfileState {
  const ProfileSaved();
}

final class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

final class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}
