import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:flutter/material.dart';

class test1 extends StatefulWidget {
  @override
  _test1State createState() => _test1State();
}

class _test1State extends State<test1> {
  double h = 300;

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onPanUpdate: (details) {
            h += (-details.delta.dy);
            if (h < 0) {
              h = 0;
            } else if (h > ScreenSizeConfig.blockSizeVertical * 100) {
              h = ScreenSizeConfig.blockSizeVertical * 100;
            }
            setState(() {});
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Image.asset(
                  "assets/user3.jpg",
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                height: h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
