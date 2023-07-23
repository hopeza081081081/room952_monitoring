import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:room952_monitoring/networking/MqttManager.dart';

///
/// it might have 2 method are 'setData', 'getCard'
///
///

class DetailsOfEachAircon {
  String cardLabel = '';
  var jsonData;

  late Widget connStatus;
  late Widget voltage;
  late Widget current;
  late Widget power;
  late Widget frequency;
  // Constructor
  DetailsOfEachAircon({required this.cardLabel});

  Widget getCard() {
    // if(jsonData != null) {
    //   if(jsonData['properties']['online']){
    //     connStatus = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/wifi-on.png', color: Colors.white, scale: 10,)), textContent: 'Online');
    //     voltage = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/voltmeter.png', color: Colors.white, scale: 10,)), textContent: jsonData['measure']['voltage'].toString()+" V.");
    //     current = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/ammeter.png', color: Colors.white, scale: 10,)), textContent: jsonData['measure']['current'].toString()+" A.");
    //     power = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/power.png', color: Colors.white, scale: 10,)), textContent: jsonData['measure']['power'].toString()+" W.");
    //     frequency = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/waves.png', color: Colors.white, scale: 10,)), textContent: jsonData['measure']['frequency'].toString()+" Hz.");
    //   }
    //   else{
    //     connStatus = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/wifi-off.png', color: Colors.white, scale: 10,)), textContent: 'Offline');
    //     voltage = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/voltmeter.png', color: Colors.white, scale: 10,)), textContent: 'n/a V.');
    //     current = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/ammeter.png', color: Colors.white, scale: 10,)), textContent: 'n/a A.');
    //     power = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/power.png', color: Colors.white, scale: 10,)), textContent: 'n/a W.');
    //     frequency = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/waves.png', color: Colors.white, scale: 10,)), textContent: 'n/a Hz.');
    //   }

    // }
    // else{
    //   connStatus = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/wifi-off.png', color: Colors.white, scale: 10,)), textContent: '-');
    //   voltage = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/voltmeter.png', color: Colors.white, scale: 10,)), textContent: '-');
    //   current = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/ammeter.png', color: Colors.white, scale: 10,)), textContent: '-');
    //   power = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/power.png', color: Colors.white, scale: 10,)), textContent: '-');
    //   frequency = _uiConponents(iconSymbol: Tab(icon: Image.asset('assets/images/waves.png', color: Colors.white, scale: 10,)), textContent: '-');
    // }
    connStatus = Consumer<MqttManager>(
      builder: (context, value, child) {
        return _uiConponents(
          iconSymbol: Tab(
              icon: Image.asset(
            'assets/images/wifi-on.png',
            color: Colors.white,
            scale: 10,
          )),
          textContent: value.i.toString(),
        );
      },
    );
    voltage = _uiConponents(
      iconSymbol: Tab(
          icon: Image.asset(
        'assets/images/voltmeter.png',
        color: Colors.white,
        scale: 10,
      )),
      textContent: jsonData['measure']['voltage'].toString() + " V.",
    );
    current = _uiConponents(
        iconSymbol: Tab(
            icon: Image.asset(
          'assets/images/ammeter.png',
          color: Colors.white,
          scale: 10,
        )),
        textContent: jsonData['measure']['current'].toString() + " A.");
    power = _uiConponents(
        iconSymbol: Tab(
            icon: Image.asset(
          'assets/images/power.png',
          color: Colors.white,
          scale: 10,
        )),
        textContent: jsonData['measure']['power'].toString() + " W.");
    frequency = _uiConponents(
        iconSymbol: Tab(
            icon: Image.asset(
          'assets/images/waves.png',
          color: Colors.white,
          scale: 10,
        )),
        textContent: jsonData['measure']['frequency'].toString() + " Hz.");

    return Container(
      child: GFCard(
        boxFit: BoxFit.cover,
        titlePosition: GFPosition.start,
        title: GFListTile(
          avatar: Image.asset(
            'assets/images/air-conditioner.png',
            color: Colors.white,
            scale: 15,
          ),
          title: Text(cardLabel),
        ),
        /*padding: EdgeInsets.only(left: 0, right: 0,),*/
        content: Container(
          /*decoration: BoxDecoration(border: Border.all(color: Colors.white)),*/
          child: Column(
            children: [
              connStatus,
              voltage,
              current,
              power,
              frequency,
            ],
          ),
        ),
      ),
    );
  }

  Widget _uiConponents(
      {required dynamic iconSymbol, required String textContent}) {
    return Container(
      /*decoration: BoxDecoration(
        border: Border.all(),
      ),*/
      margin: EdgeInsets.only(top: 10, bottom: 10),
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
              child: Text(textContent),
            ),
          ),
        ],
      ),
    );
  }

  void setData({var jsonData}) {
    this.jsonData = jsonData;
  }
}
