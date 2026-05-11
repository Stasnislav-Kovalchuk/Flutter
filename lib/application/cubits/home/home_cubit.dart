import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/connectivity_notifier.dart';
import '../../../core/services/mqtt_sensor_controller.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._connectivity,
    this._mqttController,
  ) : super(const HomeState()) {
    _wasOnline = _connectivity.isOnline;
    _connectivity.addListener(_onConnectivityChanged);
  }

  final ConnectivityNotifier _connectivity;
  final MqttSensorController _mqttController;

  late bool _wasOnline;
  bool _offlineWarningShown = false;

  void init({required bool launchedOffline}) {
    if (launchedOffline && !_offlineWarningShown) {
      _offlineWarningShown = true;
      emit(
        state.copyWith(
          snackBarMessage:
              'Ви увійшли без Інтернету (збережена сесія). MQTT та оновлення з брокера недоступні, доки не з\'явиться мережа.',
        ),
      );
    }
  }

  void setTab(int index) => emit(state.copyWith(currentIndex: index));

  void consumeSnackBar() {
    if (state.snackBarMessage == null) {
      return;
    }
    emit(state.copyWith(snackBarMessage: null));
  }

  void _onConnectivityChanged() {
    final bool online = _connectivity.isOnline;

    if (_wasOnline && !online) {
      _mqttController.disconnect();
      emit(state.copyWith(snackBarMessage: 'З\'єднання з Інтернетом втрачено'));
    } else if (!_wasOnline && online) {
      emit(state.copyWith(snackBarMessage: 'Мережу відновлено'));
      _mqttController.connectIfPossible(networkAvailable: true);
    }

    _wasOnline = online;
  }

  @override
  Future<void> close() {
    _connectivity.removeListener(_onConnectivityChanged);
    return super.close();
  }
}
