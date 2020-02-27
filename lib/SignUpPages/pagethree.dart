import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagehelper.dart';
import 'package:ecommerce_app_ui_kit/themes.dart';

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
 // List<bool> PageHelperData.interest = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Stack(
      //fit: StackFit.passthrough,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient:
                ThemeColor.getLinearGradientColor(Colors.green, Colors.yellow),
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
                    Text("Why would you like to meet them?"),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageThreevalue[0],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.interest.add("Travel");
                              } else {
                                PageHelperData.interest.remove("Travel");
                              }
                              setState(() {
                                PageHelper.pageThreevalue[0] = newValue;
                              });
                            }),
                        Text("Travel")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageThreevalue[1],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.interest.add("Dinner");
                              } else {
                                PageHelperData.interest.remove("Dinner");
                              }
                              setState(() {
                                PageHelper.pageThreevalue[1] = newValue;
                              });
                            }),
                        Text("Dinner")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageThreevalue[2],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.interest.add("Hangout");
                              } else {
                                PageHelperData.interest.remove("Hangout");
                              }
                              setState(() {
                                PageHelper.pageThreevalue[2] = newValue;
                              });
                            }),
                        Text("Hangout")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageThreevalue[3],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.interest.add("X1");
                              } else {
                                PageHelperData.interest.remove("X1");
                              }
                              setState(() {
                                PageHelper.pageThreevalue[3] = newValue;
                              });
                            }),
                        Text("X1")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: PageHelper.pageThreevalue[4],
                            onChanged: (bool newValue) {
                              if (newValue) {
                                PageHelperData.interest.add("X2");
                              } else {
                                PageHelperData.interest.remove("X2");
                              }
                              setState(() {
                                PageHelper.pageThreevalue[4] = newValue;
                              });
                            }),
                        Text("X2"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
