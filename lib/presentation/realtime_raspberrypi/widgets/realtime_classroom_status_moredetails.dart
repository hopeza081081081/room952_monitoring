import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

class RealtimeClassroomStatusMoreDetails extends StatelessWidget {
  @override
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
              Column(
                children: <Widget>[
                  RaspberryPiDataDetails(
                    iconSymbol: Icon(
                      Icons.wifi,
                      size: 40.0,
                    ),
                    textContent: Text('online'),
                  ),
                  RaspberryPiDataDetails(
                    iconSymbol: Icon(
                      FontAwesomeIcons.users,
                      size: 40.0,
                    ),
                    textContent: Text('ตรวจพบคน'),
                  ),
                  RaspberryPiDataDetails(
                    iconSymbol: Icon(
                      FontAwesomeIcons.percent,
                      size: 40.0,
                    ),
                    textContent: Text(double.parse('50.0').toStringAsFixed(2)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        print('back button is pressed.');
        return Navigator.canPop(context);
      },
    );
  }
}

class RaspberryPiDataDetails extends StatelessWidget {
  final Icon iconSymbol;
  final Text textContent;

  const RaspberryPiDataDetails(
      {required this.iconSymbol, required this.textContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      /*decoration: BoxDecoration(
        border: Border.all(),
      ),*/
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              //child: Icon(Icons.signal_cellular_4_bar),
              child: iconSymbol,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              //child: Text('5555'),
              child: textContent,
            ),
          ),
        ],
      ),
    );
  }
}
