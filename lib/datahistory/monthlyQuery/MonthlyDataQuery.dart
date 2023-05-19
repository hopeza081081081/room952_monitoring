

import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:room952_monitoring/EnvironmentVariable.dart';
import 'package:room952_monitoring/datahistory/DateRangeDisplay.dart';
import 'MonthlyDatePicker.dart';
import 'MonthlyUsedExtended.dart';
import 'MonthlyUsedSummary.dart';

class MonthlyDataQuery extends StatefulWidget {
  @override
  _MonthlyDataQueryState createState() => _MonthlyDataQueryState();
}

class _MonthlyDataQueryState extends State<MonthlyDataQuery> with AutomaticKeepAliveClientMixin{
  // Network params
  final String ipAddress = 'desolate-waters-84401.herokuapp.com';
  final String port = '3000';
  var client = http.Client();

  late MonthlyDatePicker _datePicker;
  MonthlyUsedSummary _dailySummary = MonthlyUsedSummary();
  MonthlyUsedExtended _dailySummaryExtended = MonthlyUsedExtended();
  DateRangeDisplay _dateRangeDisplay = DateRangeDisplay();
  late var uriResponse;

  DateTime? _firstDate;
  DateTime? _lastDate;

  @override
  void initState() {
    // TODO: implement initState

    _datePicker = MonthlyDatePicker(onQueryButtonTapped: onQueryButtonTapped, onDatePickerConfirmed: onDatePickerConfirmed, context: this.context,);
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _datePicker.getCustomDatePicker(),
            _dateRangeDisplay.getDateRangeDisplay(),
            _dailySummary,
            _dailySummaryExtended,
          ],
        ),
      ),
    );
  }

  void onDatePickerConfirmed(DateTime dt){
    // last date equl current date
    // first date have to be current date sub by 1

    _firstDate = DateTime.utc(dt.year, dt.month);
    // _lastDate = _firstDate.add(Duration(days: DayPicker.getDaysInMonth(dt.year, dt.month)));
    // print(DayPicker.getDaysInMonth(dt.year, dt.month));
    _lastDate = DateTime.utc(dt.year, dt.month);
    print("Current Date: ${DateTime.now()}");
    print("First Date: $_firstDate");
    print("Last Date: $_lastDate");
    setState(() {
      _dateRangeDisplay.setDateRangeLabel(
        start: 'ตั้งแต่ ${_firstDate!.day} ${EnvironmentVariable.monthList[_firstDate!.month-1]} ${_firstDate!.year}',
        end: 'จนถึง ${_firstDate!.day} ${EnvironmentVariable.monthList[_lastDate!.month-1]} ${_lastDate!.year}',
      );
      _datePicker.setDateTimeLabel(dateTimeLabel: '${EnvironmentVariable.monthList[_firstDate!.month-1]} / ${_firstDate!.year}', pickedDateTime: dt);
    });
  }

  void onQueryButtonTapped() async{
    if(_firstDate == null || _lastDate == null){
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "กรุณากรอกข้อมูล",
      );
    }
    else{
      try {
        EasyLoading.show(status: 'กำลังโหลด', maskType: EasyLoadingMaskType.black);
        uriResponse = await client.post(
            Uri.parse('http://${EnvironmentVariable.ipAddress}/dataHistory/monthly'),
            body: {'firstdate': _firstDate!.subtract(Duration(hours: 7)).toString(), 'lastdate': _lastDate!.subtract(Duration(hours: 7)).toString()}).timeout(Duration(seconds: 30));

        List<dynamic> jsonresponse = jsonDecode(uriResponse.body);
        double? aircon1EnergyUsed = 0;
        double? aircon2EnergyUsed = 0;
        double? aircon3EnergyUsed = 0;

        if(jsonresponse.isNotEmpty){
          EasyLoading.dismiss();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "เรียกดูข้อมูลสำเร็จ",
          );
          print(jsonresponse[0].toString());
          if(jsonresponse[0]['first']['aircon1energy'] == null || jsonresponse[0]['last']['aircon1energy'] == null){
            print('aircon1energy is null');
            aircon1EnergyUsed = 0;
          }
          else{
            print("aircon1energy isn't null");
            aircon1EnergyUsed = jsonresponse[0]['last']['aircon1energy'] - jsonresponse[0]['first']['aircon1energy'];
          }

          if(jsonresponse[0]['first']['aircon2energy'] == null || jsonresponse[0]['last']['aircon2energy'] == null){
            print('aircon2energy is null');
            aircon2EnergyUsed = 0;
          }
          else{
            print("aircon2energy isn't null");
            aircon2EnergyUsed = jsonresponse[0]['last']['aircon2energy'] - jsonresponse[0]['first']['aircon2energy'];
          }

          if(jsonresponse[0]['first']['aircon3energy'] == null || jsonresponse[0]['last']['aircon3energy'] == null){
            print('aircon3energy is null');
            aircon3EnergyUsed = 0;
          }
          else{
            print("aircon3energy isn't null");
            aircon3EnergyUsed = jsonresponse[0]['last']['aircon3energy'] - jsonresponse[0]['first']['aircon3energy'];
          }
          _dailySummary.gaugeKey.currentState!.updateSpeed((aircon1EnergyUsed! + aircon2EnergyUsed! + aircon3EnergyUsed!), animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey1.currentState!.updateSpeed(aircon1EnergyUsed, animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey2.currentState!.updateSpeed(aircon2EnergyUsed, animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey3.currentState!.updateSpeed(aircon3EnergyUsed, animate: true,duration: Duration(milliseconds: 3000));
        }
        else{
          EasyLoading.dismiss();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "ไม่พบข้อมูล",
          );
          _dailySummary.gaugeKey.currentState!.updateSpeed(0, animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey1.currentState!.updateSpeed(0, animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey2.currentState!.updateSpeed(0, animate: true,duration: Duration(milliseconds: 3000));
          _dailySummaryExtended.gaugeKey3.currentState!.updateSpeed(0, animate: true,duration: Duration(milliseconds: 3000));
        }

        if(uriResponse.statusCode == 200){

        }
        else if(uriResponse.statusCode == 404){
          EasyLoading.dismiss();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "Error: ${uriResponse.statusCode}",
          );
        }
        else{
          EasyLoading.dismiss();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "Error: ${uriResponse.statusCode}",
          );
        }

      }
      catch(e){
        EasyLoading.dismiss();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: e.toString(),
        );
      }
      finally {
        //client.close();
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
