import 'package:ecommerce_app_ui_kit/Pages/callpage.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';

class CallReceiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Row(
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
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(
                    Icons.call_end,
                    size: 40,
                  ),
                ),
                onTap: () async {
                  DatabaseService().onCallEnd();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

