import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Pages/home.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:geolocator/geolocator.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:provider/provider.dart';

class Hometop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _hometop();
  }
}

class _hometop extends State<Hometop> with TickerProviderStateMixin {
  AnimationController _resizableController;
  CurrentUserInfo userData;
  GlobalKey _findHereContainer = GlobalKey();

  AnimatedBuilder getContainer() {
    final checkPrevUser = Provider.of<bool>(context);
    final userData = Provider.of<CurrentUserInfo>(context);
    final String avatar = Provider.of<String>(context);

    if (avatar != null && userData != null) {
      userData.avatar = avatar;
    }
    final position = Provider.of<Position>(context);
    if (position != null) {
      DatabaseService().updateLocation(position);
    }

    return new AnimatedBuilder(
        animation: _resizableController,
        builder: (context, child) {
          return InkWell(
            child: Container(
              key: _findHereContainer,
              padding: EdgeInsets.all(24),
              child: Text("Find Here",
                  style: TextStyle(
                      color: config.Colors().yellowColor(1),
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                    color: config.Colors().mainColor(1),
                    width: _resizableController.value * 10),
              ),
            ),
            onTap: () async {
              if (checkPrevUser) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              } else {
                await Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => AccountWidget(
                              userInfo: userData,
                              tutorialShow: true,
                            )))
                    .then((onValue) async {
                  if (onValue) {
                    await Prefs.setPrevUser();
                    showCoachMarkFAB();
                  }
                });
              }
            },
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getTutorialInfo());
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 800,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  getTutorialInfo() async {
    bool value = await Prefs.getPrevUser();
    if (!value) {
      showIntroCoachMark();
    }
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('img/looking.jpeg'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 9)
            ],
          ),
          child: Container(
            alignment: AlignmentDirectional.bottomEnd,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              // width: config.App(context).appWidth(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Looking Around For a Travel Mate",
                      style: Theme.of(context).textTheme.title.merge(TextStyle(
                          height: 1,
                          fontSize: 30,
                          color: config.Colors().yellowColor(1))),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: <Widget>[
                        getContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void showIntroCoachMark() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: TyperAnimatedTextKit(
              text: ["Hola, Senor", "Let's Get  Started by Finding a Match!"],
              speed: Duration(milliseconds: 80),
              displayFullTextOnTap: true,
              pause: Duration(milliseconds: 200),
              isRepeatingAnimation: false,
              textAlign: TextAlign.center,
              textStyle: TextStyle(fontSize: 25, color: Colors.white),
              onFinished: () {
                Future.delayed(Duration(seconds: 1)).then((onValue) {
                  Navigator.of(context).pop();
                });
              },
            ),
            backgroundColor: Colors.transparent,
          );
        }).then((onValue) {
      showCoachMarkFAB();
    });
  }

  void showCoachMarkFAB() {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _findHereContainer.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.deflate(10);
    coachMarkFAB.show(
        targetContext: _findHereContainer.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Center(
              child: Text("Tap Here find a mate",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: null,
        onClose: () {
          print("CLosed");
        });
  }
}
