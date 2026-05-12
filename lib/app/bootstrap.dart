import '../core/repositories/auth_repository.dart';
import '../core/services/connectivity_notifier.dart';

class BootstrapData {
  const BootstrapData({
    required this.isLoggedIn,
    required this.offlineAutologin,
  });

  final bool isLoggedIn;
  final bool offlineAutologin;
}

Future<BootstrapData> loadBootstrap(AuthRepository authRepository) async {
  final bool loggedIn = await authRepository.isLoggedIn();
  final bool online = await ConnectivityNotifier.checkOnline();
  return BootstrapData(
    isLoggedIn: loggedIn,
    offlineAutologin: loggedIn && !online,
  );
}
