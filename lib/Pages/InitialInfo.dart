import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/prevUser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Pages/mainpage.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagehelper.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/Helper/UiHelper/loading.dart';
import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pageone.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagethree.dart';
import 'package:ecommerce_app_ui_kit/SignUpPages/pagetwo.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class InitialInfo extends StatefulWidget {
  @override
  _InitialInfoState createState() {
    return _InitialInfoState();
  }
}

class _InitialInfoState extends State<InitialInfo> {
  DatabaseService _databaseService = DatabaseService();
  final List<Container> _pages = List<Container>();
  final pageController = PageController();
  var currentPageValue = 0.0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _pages.add(Container(
      child: PageOne(),
    ));
    _pages.add(Container(
      child: PageTwo(),
    ));
    _pages.add(Container(
      child: PageThree(),
    ));
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
        if (currentPageValue > 1.5) {
          isLastPage = true;
        } else {
          isLastPage = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.red,
            child: PageView.builder(
                pageSnapping: true,
                itemCount: _pages.length,
                controller: pageController,
                itemBuilder: (BuildContext context, int index) {
                  if (index == currentPageValue.floor()) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateX(currentPageValue - index),
                      child: _pages[index],
                    );
                  } else if (index == currentPageValue.floor() + 1) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateX(currentPageValue - index),
                      child: _pages[index],
                    );
                  } else {
                    return Container(
                      child: _pages[index],
                    );
                  }
                }),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
              child: isLastPage ? Text("Let's Get Started") : Text("Next Page"),
              onPressed: () {
                if (isLastPage) {
                  if (validate()) {
                    final loading = loadingBar(context, "Updating information");
                    loading.show();
                    insertData(loading);
                  }
                } else {
                  pageController.animateToPage(currentPageValue.toInt() + 1,
                      duration: Duration(seconds: 1), curve: Curves.bounceOut);
                }
              }),
        ),
      ],
    );
  }

  bool validate() {
    print("validating");
    print(PageHelper.pageOnevalue);
    if (PageHelper.pageOnevalue.length > 0 &&
        PageHelper.pageTwovalue.length > 0 &&
        PageHelper.pageThreevalue.length > 0) {
      return true;
    }
    return false;
  }

  insertData(ProgressDialog pr) {
    SearchPrefsdata searchPrefsdata = SearchPrefsdata();
    searchPrefsdata.matchPrefs = PageHelperData.matchPrefs;
    searchPrefsdata.interest = PageHelperData.interest;
    searchPrefsdata.continent = PageHelperData.continents;
    print(searchPrefsdata.matchPrefs);
    _databaseService.setUserPrefs(searchPrefsdata).then((onValue) {
      pr.dismiss();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPageWrapper()),
          (Route<dynamic> route) => false);
    });
  }
}
