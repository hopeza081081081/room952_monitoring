import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:room952_monitoring/DataModelJson.dart';
import 'package:room952_monitoring/networking/MqttConnect.dart';
import 'package:room952_monitoring/realtime/aircontroller/mainContent/EachAirconditionCard.dart';

// ignore: must_be_immutable
class RealtimeAirconControllerMainContent extends StatefulWidget {
  MqttConnect mqttClient;
  RealtimeAirconControllerMainContent({this.mqttClient});

  @override
  _RealtimeAirconControllerMainContentState createState() => _RealtimeAirconControllerMainContentState();
}

class _RealtimeAirconControllerMainContentState extends State<RealtimeAirconControllerMainContent> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  DataModelJson dmjAircon1 = DataModelJson();
  DataModelJson dmjAircon2 = DataModelJson();
  DataModelJson dmjAircon3 = DataModelJson();

  EachAirconditionCard aircon1card;
  EachAirconditionCard aircon2card;
  EachAirconditionCard aircon3card;

  // ignore: close_sinks
  StreamController<dynamic> streamControllerForAircon = StreamController<dynamic>.broadcast();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    widget.mqttClient.clientMQTT.updates.listen(onMessage);
    widget.mqttClient.clientMQTT.onDisconnected = onDisconnected;
    if(widget.mqttClient.clientMQTT.connectionStatus.state != MqttConnectionState.connected){
      dmjAircon1.airconControllerData['properties']['online'] = false;
      dmjAircon2.airconControllerData['properties']['online'] = false;
      dmjAircon3.airconControllerData['properties']['online'] = false;
    }

    aircon1card = EachAirconditionCard(rotationController: AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: false),cardLabel: 'เครื่องปรับอากาศ 1',jsonData: dmjAircon1.airconControllerData, context: this.context);
    aircon2card = EachAirconditionCard(rotationController: AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: false),cardLabel: 'เครื่องปรับอากาศ 2',jsonData: dmjAircon2.airconControllerData, context: this.context);
    aircon3card = EachAirconditionCard(rotationController: AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: false),cardLabel: 'เครื่องปรับอากาศ 3',jsonData: dmjAircon3.airconControllerData, context: this.context);

    Timer.periodic(new Duration(seconds: 2), (timer) {
      streamControllerForAircon.add(
        [
          dmjAircon1.airconControllerData,
          dmjAircon2.airconControllerData,
          dmjAircon3.airconControllerData,
        ]
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.wind),
        title: Text('สถานะของเครื่องปรับอากาศ'),
      ),
      /*padding: EdgeInsets.only(left: 0, right: 0,),*/
      content: StreamBuilder(
        stream: this.streamControllerForAircon.stream,
        builder: airconBuilder,
      ),
    );
  }

  void onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage masPayload = c[0].payload;
    final pt = MqttPublishPayload.bytesToStringAsString(masPayload.payload.message);

    if (c[0].topic == "myFinalProject/airconController1/measure") {
      dmjAircon1.airconControllerData['measure'] = jsonDecode(pt);
      dmjAircon1.airconControllerData['properties']['online'] = true;
    }
    if (c[0].topic == "myFinalProject/airconController1/properties") {
      dmjAircon1.airconControllerData['properties'] = jsonDecode(pt);
    }

    if (c[0].topic == "myFinalProject/airconController2/measure") {
      dmjAircon2.airconControllerData['measure'] = jsonDecode(pt);
      dmjAircon2.airconControllerData['properties']['online'] = true;
    }
    if (c[0].topic == "myFinalProject/airconController2/properties") {
      dmjAircon2.airconControllerData['properties'] = jsonDecode(pt);
    }

    if (c[0].topic == "myFinalProject/airconController3/measure") {
      dmjAircon3.airconControllerData['measure'] = jsonDecode(pt);
      dmjAircon3.airconControllerData['properties']['online'] = true;
    }
    if (c[0].topic == "myFinalProject/airconController3/properties") {
      dmjAircon3.airconControllerData['properties'] = jsonDecode(pt);
    }

    if(c[0].topic == "myFinalProject/server/properties/online"){
      if(pt == 'false'){
        dmjAircon1.airconControllerData['properties']['online'] = false;
        dmjAircon2.airconControllerData['properties']['online'] = false;
        dmjAircon3.airconControllerData['properties']['online'] = false;
      }
    }
  }

  void onDisconnected(){
    print('MQTT is disconnected.');
    dmjAircon1.airconControllerData['properties']['online'] = false;
    dmjAircon2.airconControllerData['properties']['online'] = false;
    dmjAircon3.airconControllerData['properties']['online'] = false;
  }

  // ignore: missing_return
  Widget airconBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasError) {
    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          break;
        case ConnectionState.waiting:
          break;
        case ConnectionState.active:
          //print(snapshot.data);
          this.aircon1card.setData(jsonData: snapshot.data[0]);
          this.aircon2card.setData(jsonData: snapshot.data[1]);
          this.aircon3card.setData(jsonData: snapshot.data[2]);
          break;
        case ConnectionState.done:
          break;
      }
    }
    return Column(
      children: [
        this.aircon1card.getCard(),
        this.aircon2card.getCard(),
        this.aircon3card.getCard(),
      ],
    );
  }

}
