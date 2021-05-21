import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:room952_monitoring/realtime/aircontroller/moredetailsContent/DetailsOfEachAircon.dart';

// ignore: must_be_immutable
class RealtimeAirconControllerMoreDetails extends StatefulWidget {
  String pageLabel = 'page label';
  StreamController<dynamic> streamControllerForAircon;
  // ignore: cancel_subscriptions
  StreamSubscription<dynamic> streamSubscriptionForAircon;

  RealtimeAirconControllerMoreDetails({@required this.pageLabel, @required this.streamControllerForAircon});

  @override
  _RealtimeAirconControllerMoreDetailsState createState() => _RealtimeAirconControllerMoreDetailsState();
}

class _RealtimeAirconControllerMoreDetailsState extends State<RealtimeAirconControllerMoreDetails> with AutomaticKeepAliveClientMixin{
  var jsonData;

  DetailsOfEachAircon detailsOfEachAircon;

  @override
  void initState() {
    // TODO: implement initState
    print('init state');
    widget.streamSubscriptionForAircon = widget.streamControllerForAircon.stream.listen((event) {
      //print(event);
      jsonData = event;
    });

    detailsOfEachAircon = DetailsOfEachAircon(cardLabel: widget.pageLabel);

    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
              print('virtual back button is pressed.');
              widget.streamSubscriptionForAircon.pause();
              Navigator.pop(context);
            },
            type: GFButtonType.transparent,
          ),
          /*title: Text(widget.pageLabel),*/
          title: Text("รายละเอียดเพิ่มเติม"),
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: widget.streamControllerForAircon.stream,
            builder: _detailsOfEachAirconBuilder,
          ),
        ),
      ),
      onWillPop: () async {
        print('back button is pressed.');
        widget.streamSubscriptionForAircon.pause();
        return Navigator.canPop(context);
      },
    );
  }

  Widget _detailsOfEachAirconBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasError) {
    } else {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          break;
        case ConnectionState.waiting:
          break;
        case ConnectionState.active:
          //print(snapshot.data['measure']);
          this.detailsOfEachAircon.setData(jsonData: snapshot.data);
          break;
        case ConnectionState.done:
          break;
      }
    }
    return Column(
      children: [
        this.detailsOfEachAircon.getCard()
      ],
    );
  }

}
