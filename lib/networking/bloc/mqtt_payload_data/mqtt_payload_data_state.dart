part of 'mqtt_payload_data_bloc.dart';

class MqttMessagePayloadState extends Equatable {
  final dynamic messagePayload;
  const MqttMessagePayloadState({this.messagePayload});

  @override
  // TODO: implement props
  List<Object?> get props => [messagePayload];
}