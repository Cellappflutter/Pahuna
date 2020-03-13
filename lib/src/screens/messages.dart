import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/Pages/matchprofile.dart';

import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/chat.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages_select.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/MessageItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Messagelist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StartChat();
  }
}

class _StartChat extends State<Messagelist> {
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Chats"),
        body: StreamProvider.value(
          value: DatabaseService().chatlist(),
          child: Consumer<List<Friendinfo>>(
            builder: (context, items, child) {
              print(items);
              //  pr.dismiss();
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
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onTap: (){delete(item.uid);},
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
                            leading: (item.avatar != "" && item.avatar != null)
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(item.avatar),
                                    radius: ScreenSizeConfig.safeBlockVertical *
                                        3.5,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: ScreenSizeConfig.safeBlockVertical *
                                        3.5,
                                  ),
                            title: Text(item.name.toString().toUpperCase(),
                                style: Theme.of(context).textTheme.body2),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatWidget(
                                      name: item.name,
                                      avatar: item.avatar,
                                      fid: item.uid)));
                            },
                            onLongPress: () {},
                          ),
                        ));
                  },
                ),
              );
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  delete(String fid) {
    databaseService.deletechatfriend(fid);
  }
}
