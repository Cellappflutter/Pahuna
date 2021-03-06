import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Start_Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StartChat();
  }
}

class _StartChat extends State<Start_Chat> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: customAppBar(context, "Select to Chat"),
      body: StreamProvider.value(value: DatabaseService().getAllMatched(),
      child: Consumer<List<RequestedUser>>(
          builder: (context, items, child) {
            if (items == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (items.length < 1) {
              return Center(
                child:
                    Text("No Connection Request, Why dont u send some request"),
              );
            } else {
              return Container(
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return FutureProvider<String>.value(
                      value: StorageService().getAvatar(item.uid),
                      child:
                          Consumer<String>(builder: (context, avatar, child) {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: ScreenSizeConfig.blockSizeVertical * 15,
                            child: Row(
                              children: <Widget>[
                                (avatar != "" && avatar != null)
                                    ? CircleAvatar(
                                        backgroundImage:
                                        CachedNetworkImageProvider(avatar),
                                            // NetworkImage(avatar),
                                        radius:
                                            ScreenSizeConfig.safeBlockVertical *
                                                6,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius:
                                            ScreenSizeConfig.safeBlockVertical *
                                                6,
                                      ),
                                Column(
                                  children: <Widget>[
                                    Text(item.name.toString().toUpperCase()),
                                    Text(item.time.toString()),
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            print("uid = ${item.uid}");
                            print("name = ${item.name}");
                           
                          },
                        );
                      }),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
