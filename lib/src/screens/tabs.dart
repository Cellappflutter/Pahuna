import 'package:ecommerce_app_ui_kit/Model/appbaraction.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Pages/Camera.dart';
import 'package:ecommerce_app_ui_kit/Pages/profile.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/cart.dart';
import 'package:ecommerce_app_ui_kit/src/screens/home.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/DrawerWidget.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int currentTab = 1;
  int selectedTab = 1;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();

  TabsWidget({
    Key key,
    this.currentTab,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUserInfo info = Provider.of<CurrentUserInfo>(context);
    final String avatar = Provider.of<String>(context);
    if (avatar != null && info != null) {
      info.avatar = avatar;
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(info: info),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.currentTitle,
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          AppBarActions(
            uiIcon: Icons.cloud_upload,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CameraState()));
            },
          ),
          AppBarActions(
            uiIcon: UiIcons.user_1,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(editableInfo: info,)
                  // AccountWidget(
                  //       userInfo: info,
                  //     )
                      ));
            },
          ),
          AppBarActions(
            uiIcon: UiIcons.chat,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Messagelist()));
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        HomeWidget(),
      ]),
    );
  }
}
