import 'dart:async';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchRequest extends StatefulWidget {
  @override
  _MatchRequestState createState() => _MatchRequestState();
}

class _MatchRequestState extends State<MatchRequest> {
  StreamSubscription<List<RequestedUser>> matchRequestStream;
  Future<List<RequestedUser>> matchRequestDataStream;
  Stream<List<RequestedUser>> finalData;
  
  Color pressed = Colors.white;
  Key dismissableKey = Key("Dismiss");
  bool isdismiss = false;
  @override
  void initState() {
    super.initState();
    matchRequestStream = setRequestedData();
  }

  @override
  void dispose() {
    super.dispose();
    matchRequestStream.cancel();
  }

  setRequestedData() {
    matchRequestStream = DatabaseService().getMatchRequest().listen((onData) {
      print("one");
      print(onData);
      matchRequestDataStream = StorageService().getAvatarList(onData);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return FutureBuilder(
      future: matchRequestDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<RequestedUser> items = snapshot.data;
          return Container(
            color: Colors.red,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: dismissableKey,
                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      DatabaseService().acceptReq(item.uid).then((onValue) {
                        if (onValue) {
                          return Future.value(true);
                        } else {
                          return Future.value(false);
                        }
                      });
                    }
                    return Future.value(false);
                  },
                  background: Container(
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[Text("ACCEPT")],
                      )),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Column(
                      children: <Widget>[Text("REJECT")],
                    ),
                  ),
                  onDismissed: (direction) {
                    print(direction.index);
                    if (direction == DismissDirection.startToEnd) {
                      print("CONFIRM");
                      items.removeAt(index);
                    } else {
                      items.removeAt(index);
                      print("REJECT");
                    }
                  },
                  child: Card(
                    elevation: 5.0,
                    color: pressed,
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: ScreenSizeConfig.blockSizeVertical * 15,
                        child: Row(
                          children: <Widget>[
                            (item.avatar != "")
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(item.avatar),
                                    radius:
                                        ScreenSizeConfig.safeBlockVertical * 6,
                                  )
                                : CircleAvatar(
                                    // backgroundImage: NetworkImage(item.avatar),
                                    radius:
                                        ScreenSizeConfig.safeBlockVertical * 6,
                                  ),
                            Column(
                              children: <Widget>[
                                Text(item.uid.toUpperCase()),
                                Row(
                                  children: <Widget>[
                                    FlatButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            items.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.arrow_right),
                                        label: Text("ACCEPT")),
                                    FlatButton.icon(
                                        onPressed: null,
                                        icon: Icon(Icons.arrow_left),
                                        label: Text("REJECT"))
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                );
              },
            ),
          );
        } else {
          return Text("Loading");
        }
      },
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   ScreenSizeConfig().init(context);
  //   return StreamProvider.value(
  //     value: DatabaseService().getMatchRequest(),
  //     child: Consumer<List<RequestedUser>>(builder: (context, data, child) {
  //       return FutureBuilder(
  //           future: Future.delayed(Duration(seconds: 4)),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState != ConnectionState.done) {
  //               return Text("LOADING");
  //             }
  //             if (data != null) {
  //               return FutureBuilder(
  //                   future: getAvatar(data),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState != ConnectionState.done) {
  //                       return Text("LO11ADING");
  //                     }
  //                     final items = snapshot.data;
  //                     return Container(
  //                       color: Colors.red,
  //                       child: ListView.builder(
  //                         itemCount: items.length,
  //                         itemBuilder: (context, index) {
  //                           final item = items[index];
  //                           return Dismissible(
  //                             onResize: () {
  //                               print("dasdsa");
  //                             },
  //                             background: Container(
  //                                 color: Colors.green,
  //                                 child: Column(
  //                                   children: <Widget>[Text("ACCEPT")],
  //                                 )),
  //                             secondaryBackground: Container(
  //                               color: Colors.red,
  //                               child: Column(
  //                                 children: <Widget>[Text("REJECT")],
  //                               ),
  //                             ),
  //                             key: ValueKey('request'),
  //                             onDismissed: (direction) {
  //                               print(direction.index);
  //                               if (direction == DismissDirection.startToEnd) {
  //                                 print("CONFIRM");
  //                                 DatabaseService().acceptReq(item.uid);
  //                               } else {
  //                                 print("REJECT");
  //                               }
  //                             },
  //                             child: Card(
  //                               elevation: 5.0,
  //                               color: pressed,
  //                               child: Container(
  //                                   padding: EdgeInsets.all(10.0),
  //                                   height:
  //                                       ScreenSizeConfig.blockSizeVertical * 15,
  //                                   child: Row(
  //                                     children: <Widget>[
  //                                       CircleAvatar(
  //                                         backgroundImage:
  //                                             NetworkImage(item.avatar),
  //                                         radius: ScreenSizeConfig
  //                                                 .safeBlockVertical *
  //                                             6,
  //                                       ),
  //                                       Column(
  //                                         children: <Widget>[
  //                                           Text(item.uid.toUpperCase()),
  //                                           Row(
  //                                             children: <Widget>[
  //                                               FlatButton.icon(
  //                                                   onPressed: () {},
  //                                                   icon:
  //                                                       Icon(Icons.arrow_right),
  //                                                   label: Text("ACCEPT")),
  //                                               FlatButton.icon(
  //                                                   onPressed: null,
  //                                                   icon:
  //                                                       Icon(Icons.arrow_left),
  //                                                   label: Text("REJECT"))
  //                                             ],
  //                                           )
  //                                         ],
  //                                       )
  //                                     ],
  //                                   )),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   });
  //             } else {
  //               return Text("LOADING");
  //             }
  //           });
  //     }),
  //   );
  // }

  Future<List<RequestedUser>> getAvatar(List<RequestedUser> user) async {
    for (int i = 0; i < user.length; i++) {
      user[i].avatar = await StorageService().getAvatar(user[i].uid);
    }
    return user;
  }
}
