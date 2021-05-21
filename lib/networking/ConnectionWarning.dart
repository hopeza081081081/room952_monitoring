import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConnectionWarning {
  // ignore: missing_return
  Widget showConnectionWarning({String warningMsg, bool isShow}){
    if (isShow == true) {
      //if error is true then show error message box
      return Container(
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.only(bottom: 1.00),
        color: Colors.red,
        child: Row(children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.info, color: Colors.white),
          ), // icon for error message
          Text(warningMsg, style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    } else {
      return Container();
      //if error is false, return empty container.
    }
  }
}
