import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/mqtt_sensor_controller.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._mqttController) : super(const DashboardState()) {
    _mqttController.addListener(_onMqttChanged);
  }

  final MqttSensorController _mqttController;

  void applyDriveMode(String modeInput) {
    final String input = modeInput.trim().toLowerCase();

    switch (input) {
      case 'sand':
        emit(state.copyWith(
          mode: 'Sand',
          is4x4: true,
          lowGear: false,
          diffLock: false,
          error: null,
        ));
        return;
      case 'mud':
        emit(state.copyWith(
          mode: 'Mud',
          is4x4: true,
          lowGear: true,
          diffLock: true,
          error: null,
        ));
        return;
      case 'snow':
        emit(state.copyWith(
          mode: 'Snow',
          is4x4: true,
          lowGear: false,
          diffLock: false,
          error: null,
        ));
        return;
      case 'mountain':
        emit(state.copyWith(
          mode: 'Mountain',
          is4x4: true,
          lowGear: true,
          diffLock: true,
          error: null,
        ));
        return;
      case '2wd':
        emit(state.copyWith(
          mode: 'Eco Mode',
          is4x4: false,
          lowGear: false,
          diffLock: false,
          error: null,
        ));
        return;
      default:
        emit(state.copyWith(
          error: 'Невідомий режим (sand, mud, snow, mountain)',
        ));
    }
  }

  void _onMqttChanged() {
    emit(state.copyWith(
      isMqttConnected: _mqttController.isConnected,
      temperature: _mqttController.lastPayload,
    ));
  }

  @override
  Future<void> close() {
    _mqttController.removeListener(_onMqttChanged);
    return super.close();
  }
}
