part of 'mqtt_cubit.dart';

enum MqttStatus {
  initial,
  connecting,
  connected,
  disconnected,
  offlineMode,
}

final class MqttState {
  const MqttState({
    required this.status,
    required this.isOnline,
    required this.isConnecting,
    required this.isConnected,
    required this.launchedOffline,
    required this.temperature,
    required this.statusMessage,
  });

  factory MqttState.initial() => const MqttState(
        status: MqttStatus.initial,
        isOnline: true,
        isConnecting: false,
        isConnected: false,
        launchedOffline: false,
        temperature: null,
        statusMessage: null,
      );

  final MqttStatus status;
  final bool isOnline;
  final bool isConnecting;
  final bool isConnected;
  final bool launchedOffline;
  final String? temperature;
  final String? statusMessage;

  bool get canUseMqtt => !launchedOffline && isOnline;

  MqttState copyWith({
    MqttStatus? status,
    bool? isOnline,
    bool? isConnecting,
    bool? isConnected,
    bool? launchedOffline,
    String? temperature,
    String? statusMessage,
  }) {
    return MqttState(
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      launchedOffline: launchedOffline ?? this.launchedOffline,
      temperature: temperature ?? this.temperature,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
