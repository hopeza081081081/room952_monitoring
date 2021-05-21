/*
*
* File Name: RaspberrypiMoreDetails.dart
* Author: "Tanakorn Khunkhao"
* Description : This file contains some of code to perform a ui frame for display more details of Raspberry PI data.
*
* */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:room952_monitoring/networking/ConnectionWarning.dart';
import 'package:room952_monitoring/realtime/raspberryPI/moredetailsContent/DetailsOfEachRaspberryPI.dart';

// ignore: must_be_immutable
class RaspberrypiMoreDetails extends StatefulWidget {
  // ignore: close_sinks
  StreamController<dynamic> streamControllerObject;
  // Constructor
  RaspberrypiMoreDetails({this.streamControllerObject});

  @override
  _RaspberrypiMoreDetailsState createState() =>
      _RaspberrypiMoreDetailsState();
}

class _RaspberrypiMoreDetailsState
    extends State<RaspberrypiMoreDetails>
    with AutomaticKeepAliveClientMixin {

  DetailsOfEachRaspberryPI rpiObj1;
  DetailsOfEachRaspberryPI rpiObj2;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    rpiObj1 = DetailsOfEachRaspberryPI(streamControllerObject: widget.streamControllerObject,raspberryPiIndex: 0,cardTitle: 'กล้องตัวที่ 1',);
    rpiObj2 = DetailsOfEachRaspberryPI(streamControllerObject: widget.streamControllerObject,raspberryPiIndex: 1,cardTitle: 'กล้องตัวที่ 2',);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: GFAppBar(
          leading: GFIconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () async {
              rpiObj1.streamSubscriptionObject.pause();
              rpiObj2.streamSubscriptionObject.pause();
              Navigator.pop(context);
            },
            type: GFButtonType.transparent,
          ),
          title: Text("สถานะของห้องเรียน"),
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //ConnectionWarning().showConnectionWarning(warningMsg: "can't establishing connection to server.", isShow: false,),
              rpiObj1,
              rpiObj2,
            ],
          ),
        ),
      ),
      onWillPop: () async {
        print('back button is pressed.');
        rpiObj1.streamSubscriptionObject.pause();
        rpiObj2.streamSubscriptionObject.pause();
        return Navigator.canPop(context);
      },
    );
  }
}
