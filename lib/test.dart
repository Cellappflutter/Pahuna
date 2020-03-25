import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OfflineBuilder(
      connectivityBuilder: (context, connectionResult, child) {
        return Container(
          child: Text("No Net"),
        );
      },
      child: MainPageWrapper(),
    );
  }
}
