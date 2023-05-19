import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:room952_monitoring/DataModelJson.dart';
import 'package:room952_monitoring/networking/MqttConnect.dart';
import 'package:room952_monitoring/realtime/raspberryPI/mainContent/RaspberrypiCard.dart';

// ignore: must_be_immutable
class RealtimeRaspberryPi extends StatefulWidget {
  MqttConnect? mqttClient;
  RealtimeRaspberryPi({this.mqttClient});

  @override
  _RealtimeRaspberryPiState createState() =>
      _RealtimeRaspberryPiState();
}

class _RealtimeRaspberryPiState
    extends State<RealtimeRaspberryPi>
    with AutomaticKeepAliveClientMixin {

  //This section declared for general variable.
  StreamController<dynamic> streamControllerForRpiData = StreamController<dynamic>.broadcast();
  late DataModelJson dmj;
  //This section declared for general variable.

  //This section declared for widgets object.
  Widget? _innerContentVariable;
  late RaspberrypiCard _raspberrypiMainCard;
  //This section declared for widgets object.

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    dmj = DataModelJson();
    widget.mqttClient!.clientMQTT.updates!.listen(onMessage);
    widget.mqttClient!.clientMQTT.onDisconnected = onDisconnected;

    if(widget.mqttClient!.clientMQTT.connectionStatus!.state != MqttConnectionState.connected){
      dmj.rpidata[0]['online'] = false;
      dmj.rpidata[1]['online'] = false;
    }

    Timer.periodic(new Duration(seconds: 2), (timer) {
      streamControllerForRpiData.add(dmj.rpidata);
    });

    _raspberrypiMainCard = RaspberrypiCard(
        personIcon: FaIcon(
          FontAwesomeIcons.usersSlash,
          size: 50,
        ),
      indicatorText: Text('-'),
      context: this.context,
      streamControllerForRpiData: this.streamControllerForRpiData,
    );
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamControllerForRpiData.stream,
      builder: cardBuilder,
    );
  }

  // ignore: missing_return
  Widget cardBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot){
    if (snapshot.hasError) {
    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          break;
        case ConnectionState.waiting:
          break;
        case ConnectionState.active:
          _raspberrypiMainCard.setData(jsonData: snapshot);
          break;
        case ConnectionState.done:
          break;
      }
    }
    return _raspberrypiMainCard.getCard();
  }

  void onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage masPayload = c[0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(masPayload.payload.message);

    if (c[0].topic == "myFinalProject/rpi1/objDetector") {
      dmj.rpidata[0]['isPerson'] = jsonDecode(pt)['isPerson'];
      dmj.rpidata[0]['prob'] = jsonDecode(pt)['prob'];
      dmj.rpidata[0]['online'] = true;
    }
    if (c[0].topic == "myFinalProject/rpi1/onlineStatus/online") {
      dmj.rpidata[0]['online'] = pt == 'true' ? true : false;
    }

    if (c[0].topic == "myFinalProject/rpi2/objDetector") {
      dmj.rpidata[1]['isPerson'] = jsonDecode(pt)['isPerson'];
      dmj.rpidata[1]['prob'] = jsonDecode(pt)['prob'];
      dmj.rpidata[1]['online'] = true;
    }
    if (c[0].topic == "myFinalProject/rpi2/onlineStatus/online") {
      dmj.rpidata[1]['online'] = pt == 'true' ? true : false;
    }

    if(c[0].topic == "myFinalProject/server/properties/online"){
      if(pt == 'false'){
        dmj.rpidata[0]['online'] = false;
        dmj.rpidata[1]['online'] = false;
      }
    }
  }

  void onDisconnected(){
    print('MQTT is disconnected.');
    dmj.rpidata[0]['online'] = false;
    dmj.rpidata[1]['online'] = false;
  }

}
