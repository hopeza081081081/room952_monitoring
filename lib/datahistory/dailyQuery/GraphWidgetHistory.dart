import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:room952_monitoring/model/GraphHistoryDto.dart';
import 'package:room952_monitoring/repository/HistoryRepository.dart';

class GraphWidgetHistory extends StatefulWidget {
  late List<GraphHistoryDto> chartData = [
    GraphHistoryDto(
      sId: '1',
      timeStamp: DateTime(2010),
      aircon1energy: 100,
      aircon2energy: 200,
      aircon3energy: 300,
    ),
  ];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GraphWidgetHistoryState();
  }
}

class _GraphWidgetHistoryState extends State<GraphWidgetHistory> {
  @override
  Widget build(BuildContext context) {
    // for (var chartDataElement in widget.chartData) {
    //   print(chartDataElement.timeStamp);
    // }
    return GFCard(
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.plug),
        title: Text('กราฟการใช้พลังงาน'),
      ),
      content: Column(
        children: [
          Consumer<HistoryRepository>(
            builder: (context, viewModel, child) {
              print(viewModel.graphHistoryInfo.length);
              return Container(
                padding: EdgeInsets.all(0),
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.right,
                  ),
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<GraphHistoryDto, DateTime>(
                      dataSource: viewModel.graphHistoryInfo,
                      xValueMapper: (GraphHistoryDto sales, _) =>
                          sales.timeStamp,
                      yValueMapper: (GraphHistoryDto sales, _) =>
                          sales.aircon1energy,
                      name: 'Air 1',
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                    ),
                    LineSeries<GraphHistoryDto, DateTime>(
                      dataSource: viewModel.graphHistoryInfo,
                      xValueMapper: (GraphHistoryDto sales, _) =>
                          sales.timeStamp,
                      yValueMapper: (GraphHistoryDto sales, _) =>
                          sales.aircon2energy,
                      name: 'Air 2',
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                    ),
                    LineSeries<GraphHistoryDto, DateTime>(
                      dataSource: viewModel.graphHistoryInfo,
                      xValueMapper: (GraphHistoryDto sales, _) =>
                          sales.timeStamp,
                      yValueMapper: (GraphHistoryDto sales, _) =>
                          sales.aircon3energy,
                      name: 'Air 3',
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
