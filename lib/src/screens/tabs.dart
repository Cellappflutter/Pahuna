import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/home.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/DrawerWidget.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
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
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AccountWidget(
                              userInfo: info,
                            )));
                  },
                  child: Icon(
                    UiIcons.user_1,
                    color: appColors.Colors().accentColor(1),
                  ))),
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Messagelist()));
                  },
                  child: Icon(
                    UiIcons.chat,
                    color: appColors.Colors().accentColor(1),
                  ))),
        ],
      ),
      body: Stack(children: <Widget>[
        HomeWidget(),
      ]),
    );
  }
}
