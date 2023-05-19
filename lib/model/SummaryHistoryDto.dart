class SummaryHistoryDto {
  String? nId;
  EnergySummary? firstDoc;
  EnergySummary? lastDoc;

  SummaryHistoryDto({this.nId, this.firstDoc, this.lastDoc});

  SummaryHistoryDto.fromJson(Map<String, dynamic> json) {
    nId = json['_id'];
    firstDoc = json['firstDoc'] != null
        ? new EnergySummary.fromJson(json['firstDoc'])
        : null;
    lastDoc =
    json['lastDoc'] != null ? new EnergySummary.fromJson(json['lastDoc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.nId;
    if (this.firstDoc != null) {
      data['firstDoc'] = this.firstDoc!.toJson();
    }
    if (this.lastDoc != null) {
      data['lastDoc'] = this.lastDoc!.toJson();
    }
    return data;
  }
}

class EnergySummary {
  String? sId;
  DateTime? timeStamp;
  double? aircon1energy;
  double? aircon2energy;
  double? aircon3energy;

  EnergySummary(
      {this.sId,
        this.timeStamp,
        this.aircon1energy,
        this.aircon2energy,
        this.aircon3energy});

  EnergySummary.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    timeStamp = DateTime.parse(json['timeStamp']);
    aircon1energy = json['aircon1energy'];
    aircon2energy = json['aircon2energy'];
    aircon3energy = json['aircon3energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['timeStamp'] = this.timeStamp;
    data['aircon1energy'] = this.aircon1energy;
    data['aircon2energy'] = this.aircon2energy;
    data['aircon3energy'] = this.aircon3energy;
    return data;
  }
}