import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part './mqtt_data_displaying_event.dart';
part './mqtt_data_displaying_state.dart';

class MqttDataTransferBloc extends Bloc<MqttEvent, MqttState> {
  MqttDataTransferBloc(super.initialState);
  
}