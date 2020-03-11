import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Helper/UiHelper/bottomsheetUI.dart';

import 'package:ecommerce_app_ui_kit/Model/constant.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';
import 'package:ecommerce_app_ui_kit/main.dart';

class ExitPage extends StatefulWidget {
  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Container(
      height: AppColors.pageheight,
      // width: homePagewidth,
      color: Colors.yellow,
      child: Stack(
        children: <Widget>[
          Text("Exit"),
          RaisedButton(onPressed: () {
            AuthService().signOut().whenComplete(() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AuthPage()));
            });
          }),
        ],
      ),
    );
  }
}
