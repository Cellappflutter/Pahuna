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
  // @override
  // Widget build(BuildContext context) {
  //   print("dd");
  //   return StreamProvider.value(
  //     value: DatabaseService().getter(),
  //     child: Consumer<List<String>>(builder: (context, data, child) {
  //       print(data);
  //       if (data != null) {
  //         return SafeArea(
  //             child: Column(
  //           children: <Widget>[
  //             Column(
  //               children: getData(data),
  //             ),
  //             RaisedButton(
  //               onPressed: () {
  //                 DatabaseService().sendReq("one12");
  //               },
  //               child: Text("send req"),
  //             ),
  //             RaisedButton(
  //               onPressed: () {
  //                 DatabaseService().acceptReq("one12");
  //                 // DatabaseService().confirmReq();
  //               },
  //               child: Text("Accept"),
  //             ),
  //           ],
  //         ));
  //       } else
  //         return Text("Waiting");
  //     }),
  //   );
  // }

  // getData(List<String> data) {
  //   List<Widget> widgets = List<Widget>();
  //   widgets.add(Container());
  //   print("--------");
  //   print(data);
  //   // data['Accepted'].forEach((k, v) {
  //   //   print((k is int));
  //   //   print(v);
  //   // });
  //   return widgets;
  // }
}
