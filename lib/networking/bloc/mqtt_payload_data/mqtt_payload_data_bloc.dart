import "dart:convert";

import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mqtt_client/mqtt_client.dart";
import "package:room952_monitoring/networking/MqttManager.dart";

part 'mqtt_payload_data_event.dart';
part 'mqtt_payload_data_state.dart';

class MqttPayloadBloc extends Bloc<StartListeningPayloadEvent, MqttMessagePayloadState> {
  late MqttManager mqttManager;

  MqttPayloadBloc(): super(const MqttMessagePayloadState()) {
    on<StartListeningPayloadEvent>(_listeningMqttPayloadEvent);
  }

  void _listeningMqttPayloadEvent(StartListeningPayloadEvent event, Emitter<MqttMessagePayloadState> emit) {
    this.mqttManager = event.mqttManager;

    mqttManager.clientMQTT.updates!.listen((List<MqttReceivedMessage<MqttMessage>> payload) {
      final MqttPublishMessage masPayload = payload[0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(masPayload.payload.message);

      emit(jsonDecode(pt));
    });
  }
}