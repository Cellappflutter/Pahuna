import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_app_ui_kit/Helper/Animations/animation_set.dart';
import 'package:ecommerce_app_ui_kit/Helper/Animations/animator.dart';
import 'package:ecommerce_app_ui_kit/Helper/UiHelper/loading.dart';
import 'package:ecommerce_app_ui_kit/Model/constant.dart';
import 'package:ecommerce_app_ui_kit/Pages/Exit.dart';
import 'package:ecommerce_app_ui_kit/Pages/home.dart';
import 'package:ecommerce_app_ui_kit/Pages/login.dart';
import 'package:ecommerce_app_ui_kit/Pages/profile.dart';
import 'package:ecommerce_app_ui_kit/Pages/history.dart';
import 'package:ecommerce_app_ui_kit/Pages/policies.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  //Widget _homeWidgetValue=HomePage();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    if (NavBar.connection == ConnectivityResult.none) {
      showDialog(context: context);
    }
    screenHeight = ScreenSizeConfig.safeBlockVertical * 100;
    screenWidth = ScreenSizeConfig.safeBlockHorizontal * 100;
    return Scaffold(
      backgroundColor: NavBar.backgroundColor,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              menu(context),
              mainPage(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are You Sure"),
            content: Text("Do you want to exit this application?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            right: 135.0, top: 10.0, bottom: 20.0),
                        width: screenWidth,
                        height: ScreenSizeConfig.safeBlockVertical * 30,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[600],
                              offset: Offset(0.0, 2.0),
                              blurRadius: 90.0,
                              spreadRadius: 0.0,
                            )
                          ],
                        ),
                        // child: Image(
                        //   image: AssetImage('assets/images/picture.jpg'),
                        // ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenSizeConfig.safeBlockHorizontal * 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Home',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: NavBar.fontSize)),
                            onPressed: () {
                              setState(() {
                                if (isCollapsed)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                                isCollapsed = !isCollapsed;
                                _pageIndex = 1;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: NavBar.fontSize)),
                            onPressed: () {
                              setState(() {
                                if (isCollapsed)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                                isCollapsed = !isCollapsed;
                                _pageIndex = 2;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("Settings",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: NavBar.fontSize)),
                            onPressed: () {
                              setState(() {
                                if (isCollapsed)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                                isCollapsed = !isCollapsed;
                                _pageIndex = 3;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("History",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: NavBar.fontSize)),
                            onPressed: () {
                              setState(() {
                                if (isCollapsed)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                                isCollapsed = !isCollapsed;
                                _pageIndex = 4;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("Policies",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: NavBar.fontSize)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                if (isCollapsed)
                                  _controller.forward();
                                else
                                  _controller.reverse();
                                isCollapsed = !isCollapsed;
                                _pageIndex = 5;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: exitButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainPage(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: NavBar.backgroundColor,
          // child: SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                  left: ScreenSizeConfig.safeBlockHorizontal * 3,
                  right: ScreenSizeConfig.safeBlockHorizontal * 4,
                  top: ScreenSizeConfig.safeBlockVertical),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        child: Container(
                            height: ScreenSizeConfig.safeBlockVertical * 8,
                            width: ScreenSizeConfig.safeBlockVertical * 8,
                            // color: Colors.red,
                            child: Icon(Icons.menu, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      Text("PAHUNA",
                          style: TextStyle(
                              fontSize: ScreenSizeConfig.safeBlockVertical * 3,
                              color: Colors.red)),
                      InkWell(
                        splashColor: Colors.transparent,
                        child: Container(
                            height: ScreenSizeConfig.safeBlockVertical * 8,
                            width: ScreenSizeConfig.safeBlockVertical * 8,
                            child: Icon(Icons.settings, color: Colors.white)),
                        onTap: () {
                          final pr = loadingBar(context, "Logging Out");
                          pr.show();
                          AuthService().signOut().whenComplete(() {
                            pr.dismiss();

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSizeConfig.blockSizeVertical * 2),
                  homeWidget(),
                ],
              ),
            ),
          ),
          //  ),
        ),
      ),
    );
  }

  Widget homeWidget() {
    switch (_pageIndex) {
      case 1:
        {
          return HomePage();
        }

      case 2:
        {
          return ProfilePage();
        }
      case 3:
        {
          return ProfilePage();
        }
      case 4:
        {
          return HistoryPage();
        }
      case 5:
        {
          return PolicyPage();
        }
      case 6:
        {
          return ExitPage();
        }
      default:
        return HomePage();
    }
  }

  exitButton(BuildContext context) {
    return AnimatorSet(
      child: Container(
        margin:
            EdgeInsets.only(left: ScreenSizeConfig.safeBlockHorizontal * 17),
        decoration: BoxDecoration(
          //shape: BoxShape.circle,
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
        child: FlatButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text(
            "Exit App",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.0,
            ),
          ),
        ),
      ),
      animatorSet: [
        TX(
          from: -20,
          to: 15.0,
          duration: 900,
          delay: 0,
          curve: Curves.fastOutSlowIn,
        ),
        TX(
          from: 15.0,
          to: -20,
          duration: 900,
          curve: Curves.fastOutSlowIn,
        ),
      ],
    );
  }
}
