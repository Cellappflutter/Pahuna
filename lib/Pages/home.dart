import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/pages/NearbySearch.dart';
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  CurrentUserInfo userData;
  Position position;
  HomePage({this.userData,this.position});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print("dsssssssssssssss");
    print(widget.userData);
    print(widget.position);
    ScreenSizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: <Widget>[
                      Container(
                        child: NearbySearch(position: widget.position,userData: widget.userData,),
                      ),
                    ]),
                  ),
                  sizeBox(),
                  Text("Searching"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sizeBox() {
    return SizedBox(
      height: ScreenSizeConfig.safeBlockVertical * 5,
    );
  }
}
