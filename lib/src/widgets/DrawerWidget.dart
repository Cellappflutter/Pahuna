import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';

import 'package:ecommerce_app_ui_kit/Pages/login.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/user.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';

class DrawerWidget extends StatelessWidget {
  User _user = new User.init().getCurrentUser();
  AuthService authService = AuthService();
  final CurrentUserInfo info;
  DrawerWidget({this.info});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
             UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),
              accountName: Text(
                info.name,
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                info.email,
                style: Theme.of(context).textTheme.caption,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(info.avatar),
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
            //  Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountWidget(
                        userInfo: info,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartWidget()));
            },
            leading: Icon(
              UiIcons.user,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Connection Request",
              style: Theme.of(context).textTheme.subhead,
            ),
            // trailing: Chip(
            //   padding: EdgeInsets.symmetric(horizontal: 5),
            //   backgroundColor: Colors.transparent,
            //   shape: StadiumBorder(
            //       side: BorderSide(color: Theme.of(context).focusColor)),
            //   label: Text(
            //     '8',
            //     style: TextStyle(color: Theme.of(context).focusColor),
            //   ),
            // ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Tabs', arguments: 4);
          //   },
          //   leading: Icon(
          //     UiIcons.heart,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Wish List",
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   dense: true,
          //   title: Text(
          //     "Products",
          //     style: Theme.of(context).textTheme.body1,
          //   ),
          //   trailing: Icon(
          //     Icons.remove,
          //     color: Theme.of(context).focusColor.withOpacity(0.3),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Categories');
          //   },
          //   leading: Icon(
          //     UiIcons.folder_1,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Categories",
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Brands');
          //   },
          //   leading: Icon(
          //     UiIcons.folder_1,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Brands",
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          ListTile(
            dense: true,
            title: Text(
              "Application Preferences",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          ListTile(
            onTap: () {
              //Navigator.of(context).pushNamed('/Help');
            },
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
            onTap: () {
             // Navigator.of(context).pushNamed('/Tabs', arguments: 1);
            },
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
            onTap: () {
           //   Navigator.of(context).pushNamed('/Languages');
            },
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
          ListTile(
            dense: true,
            title: Text(
              "Version 0.0.1",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
