import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:room952_monitoring/EnvironmentVariable.dart';
import 'package:room952_monitoring/datahistory/DateRangeDisplay.dart';
import 'package:room952_monitoring/datahistory/dailyQuery/SummaryWidgetHistory.dart';
import 'package:room952_monitoring/repository/HistoryRepository.dart';
import 'DailyDatePicker.dart';
import 'DailyUsedExtended.dart';
import 'DailyUsedSummary.dart';
import 'GraphWidgetHistory.dart';

class DailyDataQuery extends StatefulWidget {
  @override
  _DailyDataQueryState createState() => _DailyDataQueryState();
}

class _DailyDataQueryState extends State<DailyDataQuery>
    with AutomaticKeepAliveClientMixin {
  // Network params
  var client = http.Client();
  HistoryRepository historyRepository = HistoryRepository();

  late DailyDatePicker _datePicker;
  DateRangeDisplay _dateRangeDisplay = DateRangeDisplay();
  DailyUsedSummary _dailySummary = DailyUsedSummary();
  DailyUsedExtended _dailySummaryExtended = DailyUsedExtended();
  GraphWidgetHistory _graphWidgetHistory = GraphWidgetHistory();
  SummaryWidgetHistory _summaryWidgetHistory = SummaryWidgetHistory();

  late var uriResponse;

  DateTime? _firstDate;
  DateTime? _lastDate;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    // TODO: implement initState

    _datePicker = DailyDatePicker(
      onQueryButtonTapped: onQueryButtonTapped,
      onDatePickerConfirmed: onDatePickerConfirmed,
      context: this.context,
    );
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
            _graphWidgetHistory,
            _summaryWidgetHistory,
          ],
        ),
      ),
    );
  }

  void onDatePickerConfirmed(DateTime dt) {
    // last date equl current date
    // first date have to be current date sub by 1
    _firstDate = dt;
    _lastDate = _firstDate!.add(Duration(days: 1));
    print("Current Date: ${DateTime.now()}");
    int? startDateTimeZoneDiffAsHours =
        _firstDate?.toLocal().timeZoneOffset.inHours;
    int? endDateTimeZoneDiffAsHours =
        _lastDate?.toLocal().timeZoneOffset.inHours;

    _startDate = _firstDate
        ?.toLocal()
        .subtract(Duration(hours: startDateTimeZoneDiffAsHours?.toInt() ?? 7));
    _endDate = _lastDate
        ?.toLocal()
        .subtract(Duration(hours: endDateTimeZoneDiffAsHours?.toInt() ?? 7));

    setState(() {
      //_dailySummary.key.currentState.updateSpeed(50, animate: true,duration: Duration(milliseconds: 3000));
      _dateRangeDisplay.setDateRangeLabel(
        start:
            'ตั้งแต่ ${_startDate!.day} ${EnvironmentVariable.monthList[_startDate!.month - 1]} ${_startDate!.year}',
        end:
            'จนถึง ${_endDate!.day} ${EnvironmentVariable.monthList[_endDate!.month - 1]} ${_endDate!.year}',
      );
      _datePicker.setDateTimeLabel(
          dateTimeLabel:
              '${_startDate!.day} / ${EnvironmentVariable.monthList[_startDate!.month - 1]} / ${_startDate!.year}',
          pickedDateTime: dt);
    });
  }

  void onQueryButtonTapped() async {
    if (_startDate == null || _endDate == null) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "กรุณากรอกข้อมูล",
      );
    } else {
      try {
        EasyLoading.show(
            status: 'กำลังโหลด', maskType: EasyLoadingMaskType.black);

        final historyRepositoryProvider = Provider.of<HistoryRepository>(context, listen: false);
        await historyRepositoryProvider.getGraphHistoryRepository(startDate: _startDate, endDate: _endDate);
        await historyRepositoryProvider.getEnergySummaryHistoryRepository(startDate: _startDate, endDate: _endDate);

        EasyLoading.dismiss();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "เรียกดูข้อมูลสำเร็จ",
        );

        // _graphWidgetHistory.abc.rebuild();
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: e.toString(),
        );
      } finally {
        //client.close();
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
