import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DailyHourSorting {
  List<Widget> _hourContent = [];

  Widget getHourSort() {
    return GFCard(
      boxFit: BoxFit.cover,
      title: GFListTile(
        avatar: Icon(Icons.sort),
        title: Text('การใช้พลังงานในแต่ละชั่วโมง'),
      ),
      content: Container(
        child: Column(
          children: _hourContent,
        ),
      ),
    );
  }

  Widget _content({required double energy, required DateTime dateTime}) {
    double _energy = energy;
    DateTime _dateTime = dateTime;

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.access_time,
              color: Colors.white,
              size: 50,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text('เวลา ${_dateTime.hour} นาฬิกา'),
                Text('ใช้ไป ${_energy.toStringAsFixed(2)} หน่วย'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setData({required List<dynamic> data}){
    List<dynamic> _jsonresponse = data;
    double _aircon1EnergyUsed = 0;
    double _aircon2EnergyUsed = 0;
    double _aircon3EnergyUsed = 0;
    double _sumOfEnergyUsed = 0;

    if(_hourContent.isNotEmpty){
      _hourContent.clear();
    }
    //_hourContent.add(_content());

    _jsonresponse.forEach((element) { // in each hour
      if(element['first']['aircon1energy'] == null || element['last']['aircon1energy'] == null){
        _aircon1EnergyUsed = 0;
      }
      else{
        _aircon1EnergyUsed += element['last']['aircon1energy'] - element['first']['aircon1energy'];
      }

      if(element['first']['aircon2energy'] == null || element['last']['aircon2energy'] == null){
        _aircon2EnergyUsed = 0;
      }
      else{
        _aircon2EnergyUsed += element['last']['aircon2energy'] - element['first']['aircon2energy'];
      }

      if(element['first']['aircon3energy'] == null || element['last']['aircon3energy'] == null){
        _aircon3EnergyUsed = 0;
      }
      else{
        _aircon3EnergyUsed += element['last']['aircon3energy'] - element['first']['aircon3energy'];
      }
      _sumOfEnergyUsed = _aircon1EnergyUsed + _aircon2EnergyUsed + _aircon3EnergyUsed;
      _hourContent.add(_content(energy: _sumOfEnergyUsed, dateTime: DateTime.parse(element['first']['timeStamp'])));
      _sumOfEnergyUsed = 0;
    });
  }
}
