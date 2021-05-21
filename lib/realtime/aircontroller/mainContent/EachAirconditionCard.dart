import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:room952_monitoring/DataModelJson.dart';
import 'package:room952_monitoring/realtime/aircontroller/moredetailsContent/RealtimeAirconControllerMoreDetails.dart';

class EachAirconditionCard {
  // this for variables.
  AnimationController rotationController;
  String cardLabel = '-';
  String airconStatusLabel = '-';
  double powerTresh = 20;
  dynamic statusIndicatorIcon = GFLoader(
      type:GFLoaderType.ios
  );
  var jsonData;
  BuildContext context;
  // ignore: close_sinks
  StreamController<dynamic> streamControllerForAircon = StreamController<dynamic>.broadcast();
  // this for variables.

  // this for constructor
  EachAirconditionCard({@required this.rotationController, @required this.cardLabel, @required this.jsonData, @required this.context});
  // this for constructor

  Widget getCard() {
    // adding data to stream to pass data to RealtimeAirconControllerMoreDetails
    streamControllerForAircon.add(this.jsonData);

    rotationController.stop(canceled: false);
    if(this.jsonData['properties']['online'] == false) {
      this.airconStatusLabel = 'Offline';
      this.statusIndicatorIcon = FaIcon(
        FontAwesomeIcons.infoCircle,
        size: 50,
      );
      this.rotationController.stop(canceled: false);
    }

    if(this.jsonData['properties']['online'] == true) {
      this.airconStatusLabel = '-';
      this.statusIndicatorIcon = Image.asset('assets/images/fan.png', color: Colors.white,scale: 8,);
      if(this.jsonData['measure']['power'] >= this.powerTresh){
        this.airconStatusLabel = 'กำลังทำงาน';
        this.rotationController.repeat();
      }
      else if(this.jsonData['measure']['power'] < this.powerTresh){
        this.airconStatusLabel = 'ไม่มีการทำงาน';
        rotationController.stop(canceled: false);
      }
    }

    return Container(
      /*decoration: BoxDecoration(border: Border.all(color: Colors.white)),*/
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    /*decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),*/
                    child: Image.asset('assets/images/air-conditioner.png', color: Colors.white, scale: 15,),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 20,),
                    child: Text(cardLabel),
                  ),
                ),
              ],
            ),
          ),
          Container(
            /*decoration: BoxDecoration(border: Border.all(color: Colors.blue)),*/
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    /*decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),*/
                    width: 90,
                    height: 90,
                    child: Center(
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
                        child: statusIndicatorIcon,
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(child: Text(airconStatusLabel)),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            child: Center(
              child: GFButton(
                shape: GFButtonShape.pills,
                type: GFButtonType.outline,
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RealtimeAirconControllerMoreDetails(pageLabel: this.cardLabel,streamControllerForAircon: this.streamControllerForAircon,)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setData({var jsonData}){
    this.jsonData = jsonData;
  }
}