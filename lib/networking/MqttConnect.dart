import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class MqttConnect {
  final clientMQTT = MqttServerClient('soldier.cloudmqtt.com', '');
  Future connectMQTT() async {
    clientMQTT.port = 11992;
    clientMQTT.keepAlivePeriod = 5;
    clientMQTT.autoReconnect = true;

    final connCfg = MqttConnectMessage()
        .withClientIdentifier("AndroidClient:${uuid.v4()}")
        .authenticateAs('hrvmbcju', 'g7usW2NJz0H_');
    clientMQTT.connectionMessage = connCfg;

    try {
      await clientMQTT.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      clientMQTT.disconnect();
    }

    if (clientMQTT.connectionStatus.state == MqttConnectionState.connected) {
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
        'myFinalProject/rpi1/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/rpi2/#', MqttQos.exactlyOnce);
    clientMQTT.subscribe(
        'myFinalProject/server/properties/online', MqttQos.exactlyOnce);

  }
  var uuid = Uuid();

  void pong() {
    print(
        'EXAMPLE::Ping response client callback invoked - you may want to disconnect your broker here');
  }
}
