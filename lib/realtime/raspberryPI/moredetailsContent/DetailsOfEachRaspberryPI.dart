import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

// ignore: must_be_immutable
class DetailsOfEachRaspberryPI extends StatefulWidget {
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> streamSubscriptionObject;
  StreamController<dynamic> streamControllerObject;
  int raspberryPiIndex;
  String cardTitle = 'not specific.';
  DetailsOfEachRaspberryPI({this.streamControllerObject, this.raspberryPiIndex, this.cardTitle});

  @override
  _DetailsOfEachRaspberryPIState createState() => _DetailsOfEachRaspberryPIState();
}

class _DetailsOfEachRaspberryPIState extends State<DetailsOfEachRaspberryPI> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    // TODO: implement initState
    widget.streamSubscriptionObject = widget.streamControllerObject.stream.listen((event) {
      //print(event.toString());
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.raspberryPi),
        title: Text(widget.cardTitle),
      ),
      content: Container(
        child: StreamBuilder(
          stream: widget.streamControllerObject.stream,
          builder: _detailsRaspberryPiBuilder,
        ),
      ),
    );
  }

  Widget _detailsRaspberryPiBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot){
    Widget _onlineStatus = _eachComponents(iconSymbol: Icon(Icons.wifi_off, size: 40.0,), textContent: Text('-'),);
    Widget _personStatus = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.usersSlash, size: 40.0,), textContent: Text('-'),);
    Widget _personDetectorPercontage = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.percentage, size: 40.0,), textContent: Text('-'),);

    if (snapshot.hasError) {

    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          break;
        case ConnectionState.waiting:
          break;
        case ConnectionState.active:
          if(snapshot.data[widget.raspberryPiIndex]['online'] == true){
            _onlineStatus = _eachComponents(iconSymbol: Icon(Icons.wifi, size: 40.0,), textContent: Text('online'),);
            if (snapshot.data[widget.raspberryPiIndex]['isPerson'] == true){
              _personStatus = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.users, size: 40.0,), textContent: Text('ตรวจพบคน'),);
              _personDetectorPercontage = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.percentage, size: 40.0,), textContent: Text(double.parse(snapshot.data[widget.raspberryPiIndex]['prob']).toStringAsFixed(2)),);
            }
            else{
              _personStatus = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.usersSlash, size: 40.0,), textContent: Text('ตรวจไม่พบคน'),);
              _personDetectorPercontage = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.percentage, size: 40.0,), textContent: Text('0'),);
            }
          }
          else{
            _onlineStatus = _eachComponents(iconSymbol: Icon(Icons.wifi_off, size: 40.0,), textContent: Text('offline'),);
            _personStatus = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.usersSlash, size: 40.0,), textContent: Text('-'),);
            _personDetectorPercontage = _eachComponents(iconSymbol: Icon(FontAwesomeIcons.percentage, size: 40.0,), textContent: Text('-'),);
          }
          break;
        case ConnectionState.done:
          break;
      }
    }
    return Column(
      children: <Widget>[
        _onlineStatus,
        _personStatus,
        _personDetectorPercontage,
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget _eachComponents({@required Icon iconSymbol, @required Text textContent}){
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
