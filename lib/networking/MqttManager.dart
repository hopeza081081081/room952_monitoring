import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'package:room952_monitoring/environments/AppENV.dart';

abstract class MqttManager {
  Future<MqttServerClient> connectMQTT();
  void notifyListenerTrigger();
  void pong();
  MqttServerClient getMqttServerClient();
}

class MqttManagerImpl extends ChangeNotifier implements MqttManager {
  final clientMQTT = MqttServerClient(AppENV.MqttHost, '');

  @override
  Future<MqttServerClient> connectMQTT() async {
    try {
      var uuid = Uuid();
      clientMQTT.port = AppENV.MqttPort;
      clientMQTT.keepAlivePeriod = 5;
      clientMQTT.autoReconnect = true;

      final connCfg = MqttConnectMessage()
          .withClientIdentifier("MobileClient:${uuid.v4()}")
          .authenticateAs(AppENV.MqttUserName, AppENV.MqttPassword);
      clientMQTT.connectionMessage = connCfg;

      await clientMQTT.connect();

      if (clientMQTT.connectionStatus!.state == MqttConnectionState.connected) {
        print('EXAMPLE::Mosquitto client connected');
        print('memory address of clientMQTT: ${clientMQTT.hashCode}');
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

      // clientMQTT.updates!.listen(
      //   (event) {
      //     print(event);
      //   },
      // );

      return clientMQTT;
    } catch (_) {
      clientMQTT.disconnect();
      rethrow;
    }
  }

  @override
  void notifyListenerTrigger() {
    notifyListeners();
  }

  @override
  void pong() {
    print(
        'EXAMPLE::Ping response client callback invoked - you may want to disconnect your broker here');
  }

  @override
  MqttServerClient getMqttServerClient() {
    return clientMQTT;
  }
}
