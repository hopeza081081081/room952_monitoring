import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getwidget/getwidget.dart';

// ignore: must_be_immutable
class MonthlyDatePicker {
  // callbacl function
  void Function() onQueryButtonTapped;
  void Function(DateTime dt) onDatePickerConfirmed;

  BuildContext context;
  DateTime _currentDateTime = DateTime.now();
  String dateTimeLabel = 'เดือน ปี';
  // constructor
  MonthlyDatePicker({this.onQueryButtonTapped, this.onDatePickerConfirmed, this.context});

  void setDateTimeLabel({String dateTimeLabel, DateTime pickedDateTime}) {
    this._currentDateTime = pickedDateTime;
    this.dateTimeLabel = dateTimeLabel;
  }

  Widget getCustomDatePicker(){
    return GFCard(
      padding: EdgeInsets.all(0),
      boxFit: BoxFit.cover,
      content: InkWell(
        onTap: onDatePickerTapped,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5,right: 5),
                          child: Icon(Icons.calendar_today_outlined),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5,right: 5),
                          child: Text(this.dateTimeLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GFIconButton(
                      shape: GFIconButtonShape.circle,
                      onPressed: onQueryButtonTapped,
                      icon: Icon(Icons.forward),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDatePickerTapped() async {
    await DatePicker.showDatePicker(context, currentTime: DateTime.utc(_currentDateTime.year, _currentDateTime.month), onConfirm: onDatePickerConfirmed, locale: LocaleType.th);
  }
}
