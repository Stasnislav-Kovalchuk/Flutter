import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/connectivity_notifier.dart';
import '../../../core/services/mqtt_sensor_controller.dart';

part 'mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  MqttCubit(
    this._mqttController,
    this._connectivityNotifier,
  ) : super(MqttState.initial()) {
    _mqttController.addListener(_onMqttChanged);
    _connectivityNotifier.addListener(_onConnectivityChanged);
    _onConnectivityChanged();
    _onMqttChanged();
  }

  final MqttSensorController _mqttController;
  final ConnectivityNotifier _connectivityNotifier;

  Future<void> connect({required bool launchedOffline}) async {
    if (state.launchedOffline == launchedOffline &&
        (state.status == MqttStatus.connecting ||
            state.status == MqttStatus.connected ||
            state.status == MqttStatus.offlineMode)) {
      return;
    }
    if (launchedOffline) {
      emit(state.copyWith(
        launchedOffline: true,
        status: MqttStatus.offlineMode,
      ));
      return;
    }

    emit(state.copyWith(launchedOffline: false, status: MqttStatus.connecting));
    await _mqttController.connectIfPossible(
      networkAvailable: _connectivityNotifier.isOnline,
    );
  }

  void disconnect() => _mqttController.disconnect();

  void _onMqttChanged() {
    final MqttStatus status;
    if (state.launchedOffline) {
      status = MqttStatus.offlineMode;
    } else if (_mqttController.isConnected) {
      status = MqttStatus.connected;
    } else if (_mqttController.isConnecting) {
      status = MqttStatus.connecting;
    } else {
      status = MqttStatus.disconnected;
    }

    emit(state.copyWith(
      status: status,
      isOnline: _connectivityNotifier.isOnline,
      isConnecting: _mqttController.isConnecting,
      isConnected: _mqttController.isConnected,
      temperature: _mqttController.lastPayload,
      statusMessage: _mqttController.statusMessage,
    ));
  }

  void _onConnectivityChanged() {
    emit(state.copyWith(isOnline: _connectivityNotifier.isOnline));
  }

  @override
  Future<void> close() {
    _mqttController.removeListener(_onMqttChanged);
    _connectivityNotifier.removeListener(_onConnectivityChanged);
    return super.close();
  }
}
