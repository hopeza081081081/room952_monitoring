part of 'mqtt_payload_data_bloc.dart';

class MqttManagerBlocState extends Equatable {
  final dynamic messagePayload;
  const MqttManagerBlocState({this.messagePayload});

  String getVoltage() {
    messagePayload['voltage'];
    return messagePayload['voltage'].toString();
  }

  @override
  // TODO: implement props
  List<Object?> get props => [messagePayload];
}
