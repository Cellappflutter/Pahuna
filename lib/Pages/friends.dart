import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/Pages/matchprofile.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsWidget extends StatefulWidget {
  @override
  _FriendsWidgetState createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon:
              new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Friends',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
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
                      height: MediaQuery.of(context).size.height*0.35,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/friends.png'),fit:BoxFit.fill)),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "You haven't made any friends."),
                  ],
                ),
              );
            } else {
              print(items);
              //  pr.dismiss();
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MatchProfile(userid: item.uid)));
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
