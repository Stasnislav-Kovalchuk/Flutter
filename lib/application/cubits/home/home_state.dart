part of 'home_cubit.dart';

final class HomeState {
  const HomeState({
    this.currentIndex = 0,
    this.snackBarMessage,
  });

  final int currentIndex;
  final String? snackBarMessage;

  HomeState copyWith({
    int? currentIndex,
    String? snackBarMessage,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      snackBarMessage: snackBarMessage,
    );
  }
}
