import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:room952_monitoring/EnvironmentVariable.dart';
import 'package:room952_monitoring/model/SummaryHistoryDto.dart';
import 'package:room952_monitoring/model/GraphHistoryDto.dart';


class HistoryRepository extends ChangeNotifier{
  late var httpClient;
  late List<SummaryHistoryDto> summaryHistoryInfo = [];
  late List<GraphHistoryDto> graphHistoryInfo  = [];


  HistoryRepository() {
    httpClient = http.Client();
  }

  getEnergySummaryHistoryRepository({required DateTime? startDate, required DateTime? endDate}) async {
    late var _historyResponse;
    List<SummaryHistoryDto> _historyInfo  = [];
    summaryHistoryInfo = _historyInfo;

    _historyResponse = await httpClient
        .get(
      Uri.parse(
          'http://${EnvironmentVariable.ipAddress}/dataHistory/energySummary?StartDate=$startDate&EndDate=$endDate'),
    )
        .timeout(Duration(seconds: 30));

    for (var summaryHistoryJSON in jsonDecode(_historyResponse.body)) {
      _historyInfo.add(SummaryHistoryDto.fromJson(summaryHistoryJSON));
    }
    notifyListeners();
  }

  getGraphHistoryRepository({required DateTime? startDate, required DateTime? endDate}) async {
    late var _historyResponse;
    List<GraphHistoryDto> _historyInfo  = [];
    graphHistoryInfo = _historyInfo;

    _historyResponse = await httpClient
        .get(
      Uri.parse(
          'http://${EnvironmentVariable.ipAddress}/dataHistory/chart?StartDate=$startDate&EndDate=$endDate'),
    )
        .timeout(Duration(seconds: 30));

    for (var graphHistoryJSON in jsonDecode(_historyResponse.body)) {
      _historyInfo.add(GraphHistoryDto.fromJson(graphHistoryJSON));
    }
    notifyListeners();
  }

}