import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/main.dart';

class ErrorHandlePage {
  static Widget getErrorWidget(
      BuildContext context, FlutterErrorDetails error) {
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.orangeAccent,
              size: 60,
            ),
            Text("Oops..."),
            Text("Something went wrong!"),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text("Report Issue"),
                  onPressed: () async{
                    await DatabaseService().reportIssue(error);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => InitializePage()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
