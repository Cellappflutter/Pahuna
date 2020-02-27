import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Pages/NearbySearch.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
//import 'package:ecommerce_app_ui_kit/pages/NearbySearch.dart';


class HomePage extends StatefulWidget {
  CurrentUserInfo userData;
  HomePage({this.userData});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.userData.name);
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
                        child: NearbySearch(),
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
