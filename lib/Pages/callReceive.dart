import 'package:ecommerce_app_ui_kit/Pages/callpage.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';

class CallReceiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: () async {
              await DatabaseService().disableReceiveCall();
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => CallPage(
                            channelName: DatabaseService.uid,
                          )))
                  .then((onValue) {
                DatabaseService().onCallEnd();
                Navigator.pop(context);
              });
            }),
            RaisedButton(
              onPressed: () {
                DatabaseService().onCallEnd();
                Navigator.pop(context);
              },
              child: Text("Reject"),
            )
          ],
        ),
      ),
    );
  }
}
