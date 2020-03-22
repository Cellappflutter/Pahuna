import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Pages/friends.dart';

import 'package:ecommerce_app_ui_kit/Pages/login.dart';
import 'package:ecommerce_app_ui_kit/Pages/matchprofile.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/user.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  final CurrentUserInfo info;
  DrawerWidget({this.info});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.1),
            ),
            accountName: Text(
              widget.info.name ?? "Name",
              style: Theme.of(context).textTheme.title,
            ),
            accountEmail: Text(
              widget.info.email ?? "EmailID",
              style: Theme.of(context).textTheme.caption,
            ),
            currentAccountPicture:
                (widget.info.avatar != null && widget.info.avatar != "")
                    ? CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage:
                        CachedNetworkImageProvider(widget.info.avatar), 
                        // NetworkImage(widget.info.avatar),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.blue,
                      ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: Icon(
              UiIcons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountWidget(
                        userInfo: widget.info,
                      )));
            },
            leading: Icon(
              UiIcons.user_1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CartWidget()));
            },
            leading: Icon(
              UiIcons.user,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Connection Request",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FriendsWidget(tag: "Profile",)));
            },
            leading: Icon(
              UiIcons.users,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Friends",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Application Preferences",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              UiIcons.information,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              UiIcons.settings_1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              UiIcons.planet_earth,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Languages",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () async {
              final pr = loadingBar(context, "Logging Out");
              pr.show();
              authService.signOut().whenComplete(() {
                pr.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              });
            },
            leading: Icon(
              UiIcons.upload,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          FutureBuilder(
            future: getPackageInfo(),
            builder: (context, AsyncSnapshot<String> data) {
              return ListTile(
                dense: true,
                title: Text(
                  "Version " + ((data.hasData) ? data.data : "0.0.0"),
                  style: Theme.of(context).textTheme.body1,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Theme.of(context).focusColor.withOpacity(0.3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version.toString();
  }
}
