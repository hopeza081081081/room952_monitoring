import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:room952_monitoring/realtime/raspberryPI/moredetailsContent/RaspberrypiMoreDetails.dart';

class RaspberrypiCard {
  FaIcon personIcon;
  Text indicatorText;
  BuildContext context;
  StreamController<dynamic> streamControllerForRpiData;
  //dynamic jsonData;

  RaspberrypiCard({@required this.personIcon, @required this.indicatorText, @required this.context, @required this.streamControllerForRpiData});

  Widget getCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.eye),
        title: Text('สถานะของห้องเรียน'),
      ),
      content: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: personIcon,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: indicatorText,
              ),
            ),
          ],
        ),
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            shape: GFButtonShape.pills,
            type: GFButtonType.outline,
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              print("More details button is pressed.");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RaspberrypiMoreDetails(
                  streamControllerObject: streamControllerForRpiData,
                )),
              );
            },
          ),
        ],
      ),
    );
  }

  void setData({@required dynamic jsonData}){
    //this.jsonData = jsonData;

    if (jsonData.data[0]['online'] == true || jsonData.data[1]['online'] == true) {
      if (jsonData.data[0]['isPerson'] == true || jsonData.data[1]['isPerson'] == true) {
        this.personIcon = FaIcon(
          FontAwesomeIcons.users,
          size: 50,
        );
        this.indicatorText = Text('มีการใช้งาน');
      } else {
        this.personIcon = FaIcon(
          FontAwesomeIcons.usersSlash,
          size: 50,
        );
        this.indicatorText = Text('ไม่มีการใช้งาน');
      }
    } else {
      this.personIcon = FaIcon(
        FontAwesomeIcons.infoCircle,
        size: 50,
      );
      this.indicatorText = Text('Offline');
    }
  }
}
