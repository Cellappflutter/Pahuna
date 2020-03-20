import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/Pages/matchprofile.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/chat.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class FriendsWidget extends StatefulWidget {
  final String tag;
  FriendsWidget({this.tag});
  @override
  _FriendsWidgetState createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  SlidableController slidableController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Friends"),
        body: StreamProvider.value(
          value: DatabaseService().getAllMatched(),
          child: Consumer<List<RequestedUser>>(
            builder: (context, items, child) {
              print(items);
              if (items == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (items.length < 1) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('img/friends.png'),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(height: 10),
                      Text("You haven't made any friends."),
                    ],
                  ),
                );
              } else {
                return Container(
                  color: Colors.transparent,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                          padding: EdgeInsets.all(6.0),
                          height: ScreenSizeConfig.blockSizeVertical * 10,
                          child: Slidable(
                            controller: slidableController,
                            delegate: SlidableScrollDelegate(),
                            actionExtentRatio: 0.15,
                            secondaryActions: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  DatabaseService()
                                      .removeFriend(item.uid)
                                      .then((onValue) {
                                    if (onValue) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Success"),
                                        backgroundColor: Colors.green,
                                      ));
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Process cannot be completed"),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  });
                                },
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                            child: ListTile(
                              leading: FutureBuilder(
                                  future: StorageService().getAvatar(item.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(snapshot.data),
                                        radius:
                                            ScreenSizeConfig.safeBlockVertical *
                                                3.5,
                                      );
                                    } else {
                                      return CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius:
                                            ScreenSizeConfig.safeBlockVertical *
                                                3.5,
                                      );
                                    }
                                  }),
                              title: Text(item.name.toString().toUpperCase(),
                                  style: Theme.of(context).textTheme.body2),
                              onTap: () {
                                if (widget.tag == "Profile") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MatchProfile(userid: item.uid)));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatWidget(
                                            fid: item.uid,
                                            avatar: item.avatar,
                                            name: item.name,
                                          )));
                                }
                              },
                              onLongPress: () {},
                            ),
                          ));
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
