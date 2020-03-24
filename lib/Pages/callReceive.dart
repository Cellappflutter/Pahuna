import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/callreceivestatus.dart';
import 'package:ecommerce_app_ui_kit/Pages/callpage.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';
import 'package:vibration/vibration.dart';

class CallReceiver extends StatefulWidget {
  final CallReceiveStatus callReceiver;

  const CallReceiver({Key key, this.callReceiver}) : super(key: key);

  @override
  _CallReceiverState createState() => _CallReceiverState();
}

class _CallReceiverState extends State<CallReceiver>
    with TickerProviderStateMixin {
  double height = 80;
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    Vibrate.vibrate();
    Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0)
                          .animate(_animationController),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1, end: 2)
                            .animate(_animationController),
                        child: Container(
                          height: ScreenSizeConfig.safeBlockHorizontal * 35,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2, color: Colors.green)),
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0)
                          .animate(_animationController),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1, end: 2)
                            .animate(_animationController),
                        child: Container(
                          height: ScreenSizeConfig.safeBlockHorizontal * 50,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2, color: Colors.green)),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future:
                          StorageService().getAvatar("widget.callReceiver.uid"),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            if (snapshot.data != "") {
                              return CircleAvatar(
                                radius: 80,
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data, errorListener: () {
                                  errorDialog(context,
                                      "Seems Problem with User Avatar");
                                }),
                              );
                            }
                          }
                        }
                        return CircleAvatar(
                          radius: 80,
                          child: Icon(
                            Icons.account_circle,
                            size: 80,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Icon(
                        Icons.call,
                        size: 40,
                      ),
                    ),
                    onTap: () async {
                      Vibration.cancel();
                      await handleCameraAndMic();
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => CallPage(
                                    channelName: DatabaseService.uid,
                                  )))
                          .then((onValue) {
                        DatabaseService().onCallEnd();
                        Navigator.pop(context);
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Icon(
                        Icons.call_end,
                        size: 40,
                      ),
                    ),
                    onTap: () async {
                        Vibration.cancel();
                      DatabaseService().onCallEnd();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
