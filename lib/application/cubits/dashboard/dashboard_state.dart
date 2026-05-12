part of 'dashboard_cubit.dart';

final class DashboardState {
  const DashboardState({
    this.mode = 'None',
    this.is4x4 = false,
    this.lowGear = false,
    this.diffLock = false,
    this.error,
    this.isMqttConnected = false,
    this.temperature,
  });

  final String mode;
  final bool is4x4;
  final bool lowGear;
  final bool diffLock;
  final String? error;
  final bool isMqttConnected;
  final String? temperature;

  DashboardState copyWith({
    String? mode,
    bool? is4x4,
    bool? lowGear,
    bool? diffLock,
    String? error,
    bool? isMqttConnected,
    String? temperature,
  }) {
    return DashboardState(
      mode: mode ?? this.mode,
      is4x4: is4x4 ?? this.is4x4,
      lowGear: lowGear ?? this.lowGear,
      diffLock: diffLock ?? this.diffLock,
      error: error,
      isMqttConnected: isMqttConnected ?? this.isMqttConnected,
      temperature: temperature ?? this.temperature,
    );
  }
}
