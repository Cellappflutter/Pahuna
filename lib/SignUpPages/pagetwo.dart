import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Helper/animations/animation_set.dart';
import 'package:ecommerce_app_ui_kit/Helper/animations/animator.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagehelper.dart';
import 'package:ecommerce_app_ui_kit/themes.dart';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
 // List<bool> PageHelper.pageTwovalue = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient:
                ThemeColor.getLinearGradientColor(Colors.black, Colors.blue),
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
                  children: <Widget>[
                    Text("What would looks like"),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageTwovalue[0],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.continents.add("Asian");
                              } else {
                                PageHelperData.continents.remove("Asian");
                              }
                              setState(() {
                                PageHelper.pageTwovalue[0] = newValue;
                              });
                            }),
                        Text("Asian")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageTwovalue[1],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.continents.add("European");
                              } else {
                                PageHelperData.continents.remove("European");
                              }
                              setState(() {
                                PageHelper.pageTwovalue[1] = newValue;
                              });
                            }),
                        Text("European")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageTwovalue[2],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.continents.add("African");
                              } else {
                                PageHelperData.continents.remove("African");
                              }
                              setState(() {
                                PageHelper.pageTwovalue[2] = newValue;
                              });
                            }),
                        Text("African")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageTwovalue[3],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.continents.add("X1");
                              } else {
                                PageHelperData.continents.remove("X1");
                              }
                              setState(() {
                                PageHelper.pageTwovalue[3] = newValue;
                              });
                            }),
                        Text("X1")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageTwovalue[4],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.continents.add("X2");
                              } else {
                                PageHelperData.continents.remove("X2");
                              }
                              setState(() {
                                PageHelper.pageTwovalue[4] = newValue;
                              });
                            }),
                        Text("X2"),
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

  // getVerb() {
  //   switch (PageTwo) {
  //     case "Boy":
  //       {
  //         return "he";
  //       }
  //     case "Girl":
  //       {
  //         return "she";
  //       }
  //     default:
  //       return "they";
  //   }
  // }
}
