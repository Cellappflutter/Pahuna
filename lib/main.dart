import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:ecommerce_app_ui_kit/Helper/ErrorHandler.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:ecommerce_app_ui_kit/Model/callreceivestatus.dart';
import 'package:ecommerce_app_ui_kit/Model/prevUser.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/Pages/callReceive.dart';
import 'package:ecommerce_app_ui_kit/database/Word.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Pages/login.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: config.Colors().whiteColor(1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        accentColor: config.Colors().mainDarkColor(1),
        hintColor: config.Colors().secondDarkColor(1),
        focusColor: config.Colors().accentDarkColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Color(0xFF252525)),
          headline: TextStyle(
              fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
          display1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          display2: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          display3: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: config.Colors().mainDarkColor(1)),
          display4: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              color: config.Colors().secondDarkColor(1)),
          subhead: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: config.Colors().secondDarkColor(1)),
          title: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().mainDarkColor(1)),
          body1: TextStyle(
              fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
          body2: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          caption: TextStyle(
              fontSize: 12.0, color: config.Colors().secondDarkColor(0.7)),
        ),
      ),
      home: InitializePage(),
    ),
  );
}

class InitializePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return AuthPage();
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isPrevUser;
  bool gotoLogin;
  bool islocation = false;
  bool noInternet = false;
  StreamSubscription internetStream;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    initInfo();
  }

  initInfo() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkPermission());
    _auth.currentUser().then((firebaseUser) async {
      await Future.delayed(Duration(seconds: 2));
      if (firebaseUser != null) {
        double range = await Prefs.getRangeData();
        double start = await Prefs.getStartAgeData();
        double end = await Prefs.getEndAgeData();
        DiscoverySetting.agePrefs = RangeValues(start, end);
        DiscoverySetting.range = range;
        DatabaseService.uid = firebaseUser.uid;
        await DatabaseService().initUserDB();
        setState(() {
          gotoLogin = false;
        });
      } else {
        setState(() {
          gotoLogin = true;
        });
      }
    });
  }

  checkPermission() async {
    internetStream = Connectivity().onConnectivityChanged.listen((onData) {
      if (onData == ConnectivityResult.none) {
        setState(() {
          noInternet = true;
        });
      } else {
        setState(() {
          noInternet = false;
        });
      }
    });
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    await Geolocator().checkGeolocationPermissionStatus().then((onValue) async {
      if (onValue != GeolocationStatus.granted) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    "Please enable permission for location and Restart the application."),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        await PermissionHandler().openAppSettings();
                      },
                      child: Text("OK"))
                ],
              );
            });
      } else {
        setState(() {
          islocation = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gotoLogin != null && islocation == true) {
      print(DatabaseService.uid);
      if (!gotoLogin) {
        internetStream.cancel();
        //  internetStream.
        return MainPageWrapper();
      } else {
        internetStream.cancel();
        return LoginPage();
      }
    } else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Color(0xffdd2827),
              child: Center(
                child: Image.asset(
                  "assets/pahuna_splash.png",
                  fit: BoxFit.scaleDown,
                  height: ScreenSizeConfig.safeBlockVertical * 50,
                  width: ScreenSizeConfig.safeBlockHorizontal * 50,
                ),
              ),
            ),
            (noInternet)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                        "No Internet Connection available, Make sure that Wi-Fi or mobile data is turned on, then try again",
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                  )
                : Container(),
          ],
        ),
      );
    }
  }
}

class MainPageWrapper extends StatefulWidget {
  @override
  _MainPageWrapperState createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> {
  bool isConnected;
  bool prevData = false;
  @override
  void initState() {
    super.initState();
    ProgressDialog p2 = loadingBar(context, "Searching Connection");
    Connectivity().onConnectivityChanged.listen((onData) {
      print("++++++++++++++++++++++++++++++++++++++++++");
      print(onData);
      if (onData == ConnectivityResult.none) {
        isConnected = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => p2.show());
      } else {
        if (p2.isShowing()) {
          p2.dismiss();
        }
      }
    });
  }

  showConnection(BuildContext context, String text) {
    loadingBar(context, text).show();
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return ErrorHandlePage.getErrorWidget(context, errorDetails);
    };
    ScreenSizeConfig().init(context);
    return MultiProvider(
      providers: [
        FutureProvider<List<Featuredata>>.value(value: Wordget().word()),
        StreamProvider<PrevUser>.value(
            value: DatabaseService().checkPrevUser()),
        StreamProvider<CurrentUserInfo>.value(
            value: DatabaseService().getUserData()),
        FutureProvider<String>.value(value: StorageService().getUserAvatar()),
        StreamProvider<Position>.value(value: locationStream()),
        StreamProvider<ConnectivityResult>.value(
            value: Connectivity().onConnectivityChanged),
        StreamProvider<CallReceiveStatus>.value(
            value: DatabaseService().callReceiver()),
      ],
      child: Consumer<CallReceiveStatus>(
        builder: (context, data, child) {
          if (data != null) {
            print(data);
            print(prevData);
            if (data.receiveCall && data.receiveCall != prevData) {
              print("-------------------------------vitra0000000000000000");
              prevData = true;
              DatabaseService().onCallStart();
              DatabaseService().disableReceiveCall();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CallReceiver(callReceiver: data)));
              });
            } else {
              prevData = false;
            }
          }
          return MaterialApp(
            title: 'Pahuna',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: config.Colors().whiteColor(1),
              brightness: Brightness.dark,
              accentColor: config.Colors().mainDarkColor(1),
              focusColor: config.Colors().accentColor(1),
              hintColor: config.Colors().secondColor(1),
              textTheme: TextTheme(
                button: TextStyle(color: Colors.white),
                headline: TextStyle(
                    fontSize: 20.0, color: config.Colors().secondColor(1)),
                display1: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1)),
                display2: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1)),
                display3: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainColor(1)),
                display4: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondColor(1)),
                subhead: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondColor(1)),
                title: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainColor(1)),
                body1: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondColor(1)),
                body2: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1)),
                caption: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondColor(0.6)),
              ),
            ),
            home: TabsWidget(
              currentTab: 1,
            ),
          );
        },
      ),
    );
  }

  Stream<Position> locationStream() {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
    return geolocator.getPositionStream(locationOptions);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: config.Colors().whiteColor(1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        accentColor: config.Colors().mainDarkColor(1),
        hintColor: config.Colors().secondDarkColor(1),
        focusColor: config.Colors().accentDarkColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Color(0xFF252525)),
          headline: TextStyle(
              fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
          display1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          display2: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          display3: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: config.Colors().mainDarkColor(1)),
          display4: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              color: config.Colors().secondDarkColor(1)),
          subhead: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: config.Colors().secondDarkColor(1)),
          title: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().mainDarkColor(1)),
          body1: TextStyle(
              fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
          body2: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondDarkColor(1)),
          caption: TextStyle(
              fontSize: 12.0, color: config.Colors().secondDarkColor(0.7)),
        ),
      ),
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: config.Colors().whiteColor(1),
        brightness: Brightness.dark,
        accentColor: config.Colors().mainColor(1),
        focusColor: config.Colors().accentColor(1),
        hintColor: config.Colors().secondColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
          headline:
              TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
          display1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondColor(1)),
          display2: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondColor(1)),
          display3: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: config.Colors().mainColor(1)),
          display4: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              color: config.Colors().secondColor(1)),
          subhead: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: config.Colors().secondColor(1)),
          title: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().mainColor(1)),
          body1:
              TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
          body2: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondColor(1)),
          caption: TextStyle(
              fontSize: 12.0, color: config.Colors().secondColor(0.6)),
        ),
      ),
      home: InitializePage(),
    );
  }
}
