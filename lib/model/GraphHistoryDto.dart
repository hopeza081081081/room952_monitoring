class GraphHistoryDto {
  String? sId;
  DateTime? timeStamp;
  double? aircon1energy;
  double? aircon2energy;
  double? aircon3energy;

  GraphHistoryDto({
    this.sId,
    this.timeStamp,
    this.aircon1energy,
    this.aircon2energy,
    this.aircon3energy,
  });

  GraphHistoryDto.fromJson(Map<String, dynamic> json) {
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
