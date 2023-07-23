import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'package:room952_monitoring/environments/AppENV.dart';

class MqttManager extends ChangeNotifier {
  final clientMQTT = MqttServerClient(AppENV.MqttHost, '');
  var uuid = Uuid();
  var mqttData;
  var i = 0;

  Future connectMQTT() async {
    clientMQTT.port = AppENV.MqttPort;
    clientMQTT.keepAlivePeriod = 5;
    clientMQTT.autoReconnect = true;

    final connCfg = MqttConnectMessage()
        .withClientIdentifier("MobileClient:${uuid.v4()}")
        .authenticateAs(AppENV.MqttUserName, AppENV.MqttPassword);
    clientMQTT.connectionMessage = connCfg;

    try {
      await clientMQTT.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      clientMQTT.disconnect();
    }

    if (clientMQTT.connectionStatus!.state == MqttConnectionState.connected) {
      //print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${clientMQTT.connectionStatus}');
      clientMQTT.disconnect();
    }

    clientMQTT.subscribe(
        'myFinalProject/airconController1/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/airconController2/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/airconController3/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/airconController4/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe('myFinalProject/rpi1/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe('myFinalProject/rpi2/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/server/properties/online', MqttQos.exactlyOnce);

    clientMQTT.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage masPayload = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(masPayload.payload.message);
      mqttData = jsonDecode(pt);
    });
  }

  void notifyListenerTrigger() {
    notifyListeners();
    i++;
    mqttData = mqttData;
    // print('notifyListenerTrigger');
  }

  void pong() {
    print(
        'EXAMPLE::Ping response client callback invoked - you may want to disconnect your broker here');
  }
}
