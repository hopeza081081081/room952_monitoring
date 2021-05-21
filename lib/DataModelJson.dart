import 'dart:convert';

class DataModelJson {
  var rpidata = jsonDecode(
    '[{"online":false, "isPerson":false, "prob":0.0},{"online":false, "isPerson":false, "prob":0.0}]',
  );

  var airconControllerData = jsonDecode(
    '{"properties":{"wifiLocalIP": "0.0.0.0","online":false,"bootcount":0},"measure":{"voltage": 0.0,"current": 0.0,"power": 0.0,"energy": 0.0,"frequency": 0.0}}',
  );

}