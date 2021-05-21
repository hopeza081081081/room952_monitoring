import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/getwidget.dart';

class AppInfo extends StatefulWidget {
  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GFCard(
              boxFit: BoxFit.cover,
              title: GFListTile(
                avatar: Icon(
                  Icons.info,
                  size: 40,
                ),
                title: Text(
                  'App Info',
                ),
              ),
              content: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Text('App Version 1.0.0'),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Text('Powered by Flutter'),
                          Image.asset('assets/images/flutter.png', scale: 15,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            GFCard(
              boxFit: BoxFit.cover,
              image: Image.asset('assets/images/hope.jpg'),
              title: GFListTile(
                avatar: GFAvatar(
                  backgroundImage: AssetImage('assets/images/hope.jpg'),
                ),
                title: Text('Tanakorn Khunkhao'),
                //subtitle: Text('Information Technologies @ CPC'),
              ),
              content: Text("ผู้จัดทำ"),
              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFAvatar(
                    backgroundColor: GFColors.PRIMARY,
                    child: Icon(Icons.share, color: Colors.white,),
                  ),
                  GFAvatar(
                    backgroundColor: GFColors.SECONDARY,
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                  GFAvatar(
                    backgroundColor: GFColors.SUCCESS,
                    child: Icon(Icons.phone, color: Colors.white,),
                  ),
                ],
              ),
            ),


            GFCard(
              boxFit: BoxFit.cover,
              image: Image.asset('assets/images/dream.jpg'),
              title: GFListTile(
                avatar: GFAvatar(
                  backgroundImage: AssetImage('assets/images/dream.jpg'),
                ),
                title: Text('Kanwara Boonprakob'),
                //subtitle: Text('Information Technologies @ CPC'),
              ),
              content: Text("ผู้จัดทำ"),
              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFAvatar(
                    backgroundColor: GFColors.PRIMARY,
                    child: Icon(Icons.share, color: Colors.white,),
                  ),
                  GFAvatar(
                    backgroundColor: GFColors.SECONDARY,
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                  GFAvatar(
                    backgroundColor: GFColors.SUCCESS,
                    child: Icon(Icons.phone, color: Colors.white,),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
