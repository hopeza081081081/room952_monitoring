import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:room952_monitoring/networking/MqttManager.dart';

class RealtimeClassroomStatus extends StatelessWidget {
  final MqttManager mqttManager;

  const RealtimeClassroomStatus({super.key, required this.mqttManager});

  final FaIcon personIcon = const FaIcon(
    FontAwesomeIcons.users,
    size: 50,
  );
  // FaIcon personIcon = FaIcon(
  //   FontAwesomeIcons.usersSlash,
  //   size: 50,
  // );
  // FaIcon personIcon = FaIcon(
  //   FontAwesomeIcons.circleInfo,
  //   size: 50,
  // );

  final Text indicatorText = const Text('asd');

  @override
  Widget build(BuildContext context) {
    MqttServerClient mqttServerClient = mqttManager.getMqttServerClient();
    print('memory address of mqttServerClient: ${mqttServerClient.hashCode}');
    mqttServerClient.updates!.listen(
      (event) {
        // print(event);
      },
    );

    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.eye),
        title: Text('สถานะของห้องเรียน'),
      ),
      content: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: personIcon,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: indicatorText,
              ),
            ),
          ],
        ),
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            shape: GFButtonShape.pills,
            type: GFButtonType.outline,
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              print("More details button is pressed.");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => RaspberrypiMoreDetails(
              //       streamControllerObject: streamControllerForRpiData,
              //     ),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
