import 'package:flutter/widgets.dart';
import 'package:getwidget/components/card/gf_card.dart';

// ignore: must_be_immutable
class DateRangeDisplay {
  String startDate = "ตั้งแต่ -";
  String endDate = "จนถึง -";

  void setDateRangeLabel({required String start, required String end}){
    this.startDate = start;
    this.endDate = end;
  }

  Widget getDateRangeDisplay(){
    return GFCard(
      /*padding: EdgeInsets.all(0),*/
      boxFit: BoxFit.cover,
      content: Center(
        child: Column(
          children: <Widget>[
            Text(this.startDate),
            Text(this.endDate),
          ],
        ),
      ),
    );
  }



}

