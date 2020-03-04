import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/chat.dart';
import 'package:ecommerce_app_ui_kit/src/screens/favorites.dart';
import 'package:ecommerce_app_ui_kit/src/screens/home.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages.dart';
import 'package:ecommerce_app_ui_kit/src/screens/notifications.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/DrawerWidget.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/FilterWidget.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/ShoppingCartButtonWidget.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int currentTab = 2;
  int selectedTab = 2;
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
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Notifications';
          widget.currentPage = NotificationsWidget();
          break;
        case 1:
          widget.currentTitle = 'Account';
          widget.currentPage = AccountWidget();
          break;
        case 2:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeWidget();
          break;
        case 3:
          widget.currentTitle = 'Messages';
          widget.currentPage = MessagesWidget();
          break;
        case 4:
          widget.currentTitle = 'Favorites';
          widget.currentPage = FavoritesWidget();
          break;
        case 5:
          widget.selectedTab = 3;
          widget.currentTitle = 'Chat';
          widget.currentPage = ChatWidget();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUserInfo info = Provider.of<CurrentUserInfo>(context);
    final String avatar = Provider.of<String>(context);
    if (avatar != null && info != null) {
      info.avatar = avatar;
    //  info.image=Image.network(avatar);
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(info:info),
      endDrawer: FilterWidget(),
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
                      builder: (context) => AccountWidget(userInfo: info)));
                },
                child: Icon(UiIcons.user_1,color: appColors.Colors().accentColor(1),)
              )),
        ],
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
        currentIndex: widget.selectedTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(UiIcons.bell),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.user_1),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: appColors.Colors().mainColor(1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(UiIcons.home,
                    color: appColors.Colors().whiteColor(1)),
              )),
          BottomNavigationBarItem(
            icon: new Icon(UiIcons.chat),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: new Icon(UiIcons.heart),
            title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}
