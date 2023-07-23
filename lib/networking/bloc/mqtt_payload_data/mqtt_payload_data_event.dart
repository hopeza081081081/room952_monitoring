part of 'mqtt_payload_data_bloc.dart';

class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StartListeningPayloadEvent extends MqttEvent {
  final MqttManager mqttManager;

  StartListeningPayloadEvent({required this.mqttManager});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
