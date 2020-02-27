import 'package:ecommerce_app_ui_kit/Helper/Animations/animation_set.dart';
import 'package:ecommerce_app_ui_kit/Helper/Animations/animator.dart';
import 'package:flutter/material.dart';
//import 'package:ecommerce_app_ui_kit/Helper/animations/animation_set.dart';
//import 'package:ecommerce_app_ui_kit/Helper/animations/animator.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagehelper.dart';
import 'package:ecommerce_app_ui_kit/themes.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  //List<bool> PageHelperData.matchPrefs = [false, false, false, false,false ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient:
                ThemeColor.getLinearGradientColor(Colors.red, Colors.blue),
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                child: Container(
                  color: Colors.red.withOpacity(0.3),
                  height: 200,
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Choose Your Mate Type."),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageOnevalue[0],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.matchPrefs.add("Girl");
                              } else {
                                PageHelperData.matchPrefs.remove("Girl");
                              }
                              setState(() {
                                PageHelper.pageOnevalue[0] = newValue;
                              });
                            }),
                        Text("Girl")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageOnevalue[1],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.matchPrefs.add("Boy");
                              } else {
                                PageHelperData.matchPrefs.remove("Boy");
                              }
                              setState(() {
                                PageHelper.pageOnevalue[1] = newValue;
                              });
                            }),
                        Text("Boy")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageOnevalue[2],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.matchPrefs.add("Group");
                              } else {
                                PageHelperData.matchPrefs.remove("Group");
                              }
                              setState(() {
                                PageHelper.pageOnevalue[2] = newValue;
                              });
                            }),
                        Text("Group")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageOnevalue[3],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.matchPrefs.add("Couple");
                              } else {
                                PageHelperData.matchPrefs.remove("Couple");
                              }
                              setState(() {
                                PageHelper.pageOnevalue[3] = newValue;
                              });
                            }),
                        Text("Couple")
                      ],
                    ),
                  ],
                ),
              ),
              AnimatorSet(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      "Swipe to Next Page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                animatorSet: [
                  Serial(
                    duration: 2000,
                    serialList: [
                      TX(
                          from: ScreenSizeConfig.blockSizeHorizontal * 50,
                          to: ScreenSizeConfig.blockSizeHorizontal * 25,
                          curve: Curves.easeInOut),
                      // O(
                      //     from: 0.5,
                      //     to: 0.9,
                      //     delay: 1000,
                      //     curve: Curves.easeInOut),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
