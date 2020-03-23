import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/Animations/ripples.dart';
import 'package:ecommerce_app_ui_kit/Helper/constant.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Helper/search_bottomsheet.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';

import 'package:geolocator/geolocator.dart';

import 'package:ecommerce_app_ui_kit/Pages/bigmess.dart';

import 'package:provider/provider.dart';

class NearbySearch extends StatefulWidget {
  CurrentUserInfo userData;
  Position position;

  NearbySearch({this.userData, this.position});
  final double size = 20.0;

  final Color color = pulsateColor;
  @override
  _NearbySearchState createState() => _NearbySearchState();
}

class _NearbySearchState extends State<NearbySearch>
    with TickerProviderStateMixin {
  SearchPrefsdata searchPrefsdata;
  Geodesy geodesy = Geodesy();
  AnimationController _controller;
  final double iconSize = ScreenSizeConfig.safeBlockHorizontal * 7;
  List<AnimationController> controllers = List<AnimationController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedIcon() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: ScaleTransition(
          scale: Tween(begin: 0.55, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: const PulsateCurve(),
            ),
          ),
          child: Icon(
            Icons.supervised_user_circle,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Center(
      child: Icon(
        Icons.access_alarm,
        size: iconSize,
        color: Colors.red,
      ),
    );
  }

  Future<List<Widget>> userWidgets(List<UserData> info) async {
    List<Widget> widgets = List<Widget>();
    print("UserWidgets Vitra");

    print(info);
    for (int i = 0; i < info.length; i++) {
      String avatar = await StorageService().getAvatar(info[i].uid);
      print("------------------------------");
      print(avatar);
      print(info[i].uid);
      print(info.length);
      print(-(ScreenSizeConfig.blockSizeHorizontal *
          8 *
          cos(info[i].bearing) *
          (info[i].distance / 1000)));
      print(ScreenSizeConfig.blockSizeVertical *
          8 *
          sin(info[i].bearing) *
          (info[i].distance / 1000));

      widgets.add(
        AlignPositioned(
          dx: -(ScreenSizeConfig.blockSizeHorizontal *
              8 *
              cos(info[i].bearing) *
              (info[i].distance / 1000)),
          dy: ScreenSizeConfig.blockSizeVertical *
              8 *
              sin(info[i].bearing) *
              (info[i].distance / 1000),
          child: InkWell(
            child: (avatar != null && avatar != "")
                ? CircleAvatar(
                    backgroundImage:
                        //(avatar != null && avatar != "")
                        (
                          CachedNetworkImageProvider(avatar)
                          // NetworkImage(avatar)
                          ),

                    //    : AssetImage("assets/facebook.png"),
                    radius: 15,
                  )
                : CircleAvatar(
                    child: Icon(UiIcons.user_3),
                    radius: 15,
                  ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return  CustomScroll(requestData:info[i],userData: widget.userData,); 
                }
              );
 
            },
          ),
        ),
      );
    }
    return widgets;
  }

  Future<List<UserData>> getRangedData(
      List<UserData> info, Position position) async {
    List<UserData> newInfo = List<UserData>();
    print("rangeee33333333333333333333333333rrr");
    print(info);
    if (info != null &&
        info.length > 0 &&
        position.latitude != null &&
        position.longitude != null) {
      print(info.length);
      for (int i = 0; i < info.length; i++) {
        print(info[i].latitude);
        info[i].bearing = geodesy.bearingBetweenTwoGeoPoints(
            LatLng(position.latitude, position.longitude),
            LatLng(info[i].latitude, info[i].longitude));
        info[i].distance = await Geolocator().distanceBetween(position.latitude,
            position.longitude, info[i].latitude, info[i].longitude);
        print(info[i].distance);
        print("dssssssss");
        if ((info[i].distance < (DiscoverySetting.range * 1000)) &&
            (info[i].age > DiscoverySetting.agePrefs.start) &&
            (info[i].age < DiscoverySetting.agePrefs.end)) {
          newInfo.add(info[i]);
        }
      }
    }
    return newInfo;
  }

  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    _controller.repeat();
    print(widget.userData.interest.toString() +
        "" +
        widget.userData.matchPrefs.toString() +
        "" +
        widget.userData.name +
        "" +
        widget.userData.continent.toString());
    print("000000000000000000000000000");
    return StreamProvider.value(
      value: _databaseService.getOnlineUsers(widget.userData),
      child: CustomPaint(
        painter: CirclePainter(
          _controller,
          color: widget.color,
        ),
        child: Stack(
          children: <Widget>[
            Text(
                widget.position.latitude.toString() ??
                    "" + " , " + widget.position.longitude.toString() ??
                    "",
                style: TextStyle(color: Colors.yellow, fontSize: 30)),
            Center(
              child: SizedBox(
                width: widget.size * 5.125,
                height: widget.size * 5.125,
                child: _animatedIcon(),
              ),
            ),
            Consumer<List<UserData>>(builder: (context, data, child) {
              return FutureBuilder(
                  future: getRangedData(data, widget.position),
                  builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                          future: userWidgets(snapshot.data),
                          builder: (context, snapshotData) {
                            if (snapshotData.hasData) {
                              return Stack(
                                children: snapshotData.data,
                              );
                            } else {
                              return Container(
                                height: 0,
                              );
                            }
                          });
                    } else {
                      print("----------------NODATA_-----------------");
                      return Container(
                        height: 0,
                      );
                    }
                  });
            }),
          ],
        ),
      ),
    );
  }
}
