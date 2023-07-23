import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:room952_monitoring/DataModelJson.dart';
import 'package:room952_monitoring/networking/MqttManager.dart';
import 'package:room952_monitoring/networking/bloc/mqtt_payload_data/mqtt_payload_data_bloc.dart';
import 'package:room952_monitoring/realtime/aircontroller/mainContent/EachAirconditionCard.dart';

// ignore: must_be_immutable
class RealtimeAirconditionBox extends StatefulWidget {
  // MqttManager? mqttClient;
  // RealtimeAirconditionBox({this.mqttClient});
  // _RealtimeAirconditionBoxState({Key? key, this.title}) : super(key: key);
  // final String? title;

  @override
  _RealtimeAirconditionBoxState createState() =>
      _RealtimeAirconditionBoxState();
}

class _RealtimeAirconditionBoxState extends State<RealtimeAirconditionBox> {
  @override
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      title: GFListTile(
        avatar: FaIcon(FontAwesomeIcons.wind),
        title: Text('สถานะของเครื่องปรับอากาศ'),
      ),
      /*padding: EdgeInsets.only(left: 0, right: 0,),*/
      content: AirconditionCard(),
    );
  }
}

class AirconditionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<MqttManagerBloc, MqttManagerBlocState>(
      builder: (context, state) {
        print(state.messagePayload);
        return Container(
          /*decoration: BoxDecoration(border: Border.all(color: Colors.white)),*/
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        /*decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),*/
                        child: Image.asset(
                          'assets/images/air-conditioner.png',
                          color: Colors.white,
                          scale: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text('cardLabel'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                /*decoration: BoxDecoration(border: Border.all(color: Colors.blue)),*/
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        /*decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),*/
                        width: 90,
                        height: 90,
                        child: Center(
                            // child: RotationTransition(
                            //   turns: Tween(begin: 0.0, end: 1.0).animate(
                            //     AnimationController(
                            //       duration: const Duration(milliseconds: 1000),
                            //       vsync: this,
                            //     ),
                            //   ),
                            //   child: GFLoader(type: GFLoaderType.ios),
                            // ),
                            ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          state.messagePayload.toString(),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Container(
                child: Center(
                  child: GFButton(
                    shape: GFButtonShape.pills,
                    type: GFButtonType.outline,
                    child: FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           RealtimeAirconControllerMoreDetails(
                      //             pageLabel: this.cardLabel,
                      //             streamControllerForAircon:
                      //                 this.streamControllerForAircon,
                      //           )),
                      // );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
