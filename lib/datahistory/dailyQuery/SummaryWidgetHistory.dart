import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:room952_monitoring/model/SummaryHistoryDto.dart';
import 'package:room952_monitoring/repository/HistoryRepository.dart';

class SummaryWidgetHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SummaryWidgetHistoryState();
  }
}

class _SummaryWidgetHistoryState extends State<SummaryWidgetHistory> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GFCard(
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.plug),
        title: Text('ยอดรวมการใช้พลังงาน'),
      ),
      content: Consumer<HistoryRepository>(
        builder: (context, viewModel, child) {
          late List<Container> ctnList = [];
          for (SummaryHistoryDto d in viewModel.summaryHistoryInfo) {
            ctnList.add(
              Container(
                padding: EdgeInsets.all(0),
                child: GFListTile(
                  titleText: 'aircon1energy',
                  subTitleText: d.firstDoc?.aircon1energy.toString(),
                  icon: Icon(Icons.favorite),
                ),
              ),
            );
          }

          return Column(
            children: ctnList,
          );
        },
      ),
    );
  }
}
