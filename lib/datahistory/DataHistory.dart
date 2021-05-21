import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room952_monitoring/datahistory/yearlyQuery/YearlyDataQuery.dart';
import 'dailyQuery/DailyDataQuery.dart';
import 'monthlyQuery/MonthlyDataQuery.dart';

class DataHistory extends StatefulWidget {
  @override
  _DataHistoryState createState() => _DataHistoryState();
}

class _DataHistoryState extends State<DataHistory> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin{
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'รายวัน'),
    Tab(text: 'รายเดือน'),
    Tab(text: 'รายปี'),
  ];

  TabController _tabController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: myTabs.length);
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: myTabs,
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DailyDataQuery(),
          MonthlyDataQuery(),
          YearlyDataQuery(),
        ],
      ),
    );
    /*return Container(
      child: Text('555'),
    );*/
  }
}
