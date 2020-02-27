import 'package:ecommerce_app_ui_kit/database/auth.dart';
import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:flutter/material.dart';


class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Stack(
        children: <Widget>[
          Text("History"),
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
