import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part 'mqtt_payload_data_event.dart';
part 'mqtt_payload_data_state.dart';

class MqttManagerBloc extends Bloc<MqttManagerBlocEvent, MqttManagerBlocState> {
  MqttManagerBloc() : super(const MqttManagerBlocState()) {
    on<StartListeningPayloadEvent>(_listeningMqttPayload);
  }

  void _listeningMqttPayload(
      StartListeningPayloadEvent event, Emitter<MqttManagerBlocState> emit) {
    emit(MqttManagerBlocState(messagePayload: event.mqttMessagePayload));
  }
}
