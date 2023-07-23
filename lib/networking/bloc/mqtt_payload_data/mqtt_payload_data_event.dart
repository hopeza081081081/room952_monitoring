part of 'mqtt_payload_data_bloc.dart';

class MqttManagerBlocEvent extends Equatable {
  const MqttManagerBlocEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StartListeningPayloadEvent extends MqttManagerBlocEvent {
  final dynamic mqttMessagePayload;

  StartListeningPayloadEvent({required this.mqttMessagePayload});

  @override
  // TODO: implement props
  List<Object?> get props => [mqttMessagePayload];
}
