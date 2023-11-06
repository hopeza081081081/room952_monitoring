import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:room952_monitoring/AppInfo.dart';
import 'package:room952_monitoring/datahistory/DataHistory.dart';
import 'package:room952_monitoring/networking/ConnectionWarning.dart';
import 'package:room952_monitoring/networking/MqttManager.dart';
import 'package:room952_monitoring/presentation/realtime_aircondition/realtime_aircondition_box.dart';
import 'package:room952_monitoring/presentation/realtime_raspberrypi/widgets/realtime_classroom_status.dart';
import 'package:room952_monitoring/realtime/raspberryPI/mainContent/RealtimeRaspberryPi.dart';
import 'package:room952_monitoring/utils/injection.dart' as di;

void main() async {
  di.getInjection();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room 952 Monitoring.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Room 952 Monitoring.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title});
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  String appbarTitle = "ข้อมูลจากอุปกรณ์ต่าง ๆ";
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool isWiFiConnected = false;
  bool isInternetOn = true;
  bool isConnectionWarningShown = false;
  late ConnectionWarning connBarWarning;

  @override
  initState() {
    di.locator<MqttManager>().connectMQTT();
    connBarWarning = ConnectionWarning();
    _connChecker();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 24,
        title: Center(
          child: Text(appbarTitle),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // connBarWarning.showConnectionWarning(
                    //   warningMsg: "can't establishing connection to server.",
                    //   isShow: isConnectionWarningShown,
                    // ),
                    RealtimeClassroomStatus(),
                    RealtimeAirconditionBox(),
                  ],
                ),
              ),
            ),
            DataHistory(),
            AppInfo(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('ภาพรวม'),
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            title: Text('ข้อมูลสรุป'),
            icon: Icon(
              Icons.data_usage,
              color: Colors.white,
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            title: Text('เกี่ยวกับ'),
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
    // return Scaffold();
  }

  void onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage masPayload = c[0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(masPayload.payload.message);

    // print(jsonDecode(pt));

    if (c[0].topic == "myFinalProject/airconController4/measure") {
      
    }
    // if (c[0].topic == "myFinalProject/airconController1/measure") {}
    // if (c[0].topic == "myFinalProject/airconController1/properties") {}

    // if (c[0].topic == "myFinalProject/airconController2/measure") {}
    // if (c[0].topic == "myFinalProject/airconController2/properties") {}

    // if (c[0].topic == "myFinalProject/airconController3/measure") {}
    // if (c[0].topic == "myFinalProject/airconController3/properties") {}

    // if (c[0].topic == "myFinalProject/server/properties/online") {
    //   if (pt == 'false') {}
    // }
  }

  void onConnected() {
    // mqttClient.clientMQTT.updates!.listen(onMessage);
    // CoolAlert.show(
    //   context: context,
    //   type: CoolAlertType.success,
    //   text: "เชื่อมต่อแล้ว",
    // );
    // setState(() {
    //   isConnectionWarningShown = false;
    // });
  }

  void onDisconnected() {
    // mqttClient.clientMQTT.doAutoReconnect(force: true);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: "การเชื่อมต่อขัดข้อง",
    );
    setState(() {
      isConnectionWarningShown = true;
    });
  }

  void onPageChanged(int pageIndex) {
    setState(() => _selectedIndex = pageIndex);
    switch (pageIndex) {
      case 0:
        {
          appbarTitle = "ข้อมูลจากอุปกรณ์ต่าง ๆ";
        }
        break;

      case 1:
        {
          appbarTitle = "ข้อมูลการใช้พลังงาน";
        }
        break;

      case 2:
        {
          appbarTitle = "เกี่ยวกับ";
        }
        break;

      default:
        {}
        break;
    }
  }

  void _connChecker() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    // print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    // print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    // print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    // var listener = DataConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case DataConnectionStatus.connected:
    //       print('Data connection is available.');
    //       break;
    //     case DataConnectionStatus.disconnected:
    //       setState(() {
    //         isConnectionWarningShown = true;
    //       });
    //       print('You are disconnected from the internet.');
    //       break;
    //   }
    // });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 30));
    // await listener.cancel();
  }
}
