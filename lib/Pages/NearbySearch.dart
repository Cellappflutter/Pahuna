import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:ecommerce_app_ui_kit/Helper/Animations/ripples.dart';
import 'package:ecommerce_app_ui_kit/Helper/constant.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';

import 'package:geolocator/geolocator.dart';
import 'package:grafpix/icons.dart';
import 'package:grafpix/pixbuttons/radial.dart';

import 'package:provider/provider.dart';

class NearbySearch extends StatefulWidget {
    CurrentUserInfo userData;
  Position position;
  NearbySearch({this.userData,this.position});
  final double size = 10.0;
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
            Icons.access_alarm,
            size: iconSize,
            color: Colors.yellow,
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

  List<Widget> userWidgets(List<UserData> info) {
    List<Widget> widgets = List<Widget>();
    print("UserWidgets Vitra");
    print(info);
    for (int i = 0; i < info.length; i++) {
      print("------------------------------");
      print(info.length);
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
          child: PixButton(
            icon: PixIcon.bomb,
            radius: 12,
            onPress: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (builder) {
                    return Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10)
                      ]),
                      margin: EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: CircleAvatar(),
                            ),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.green,
                              child: Column(
                                children: <Widget>[
                                  Text(info[i].uid),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text('Send Request'),
                                          onPressed: () {
                                            final pr = loadingBar(
                                                context, "Sending Request");
                                            pr.show();
                                            DatabaseService()
                                                .sendReq(info[i].uid)
                                                .then((onValue) {
                                              pr.dismiss();
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10.0),
                                        RaisedButton(
                                          child: Text('Follow'),
                                          onPressed: () {},
                                        )
                                      ]),
                                ],
                              ),
                            ),
                            Container(
                              height: 200,
                              color: Colors.blue,
                            ),
                            Container(
                              height: 200,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
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
    print(info.length);
    print(position.latitude);
    print(position.longitude);
    if (info != null &&
        info.length > 0 &&
        position.latitude != null &&
        position.longitude != null) {
      print(info.length);
      // newInfo=withInRangeData(info);
      for (int i = 0; i < info.length; i++) {
        print(";;;;;;;;;;;;;;;;;;;;;;;;;;");
        print(info[i].latitude);
        info[i].bearing = geodesy.bearingBetweenTwoGeoPoints(
            LatLng(position.latitude, position.longitude),
            LatLng(info[i].latitude, info[i].longitude));
        info[i].distance = await Geolocator().distanceBetween(position.latitude,
            position.longitude, info[i].latitude, info[i].longitude);
        //if (info[i].distance > -widget.searchData.range) {
        newInfo.add(info[i]);
        // }
      }
    }
    return newInfo;
  }

  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    //final position = Provider.of<Position>(context) ?? Position();
    //final userInfo= Provider.of< CurrentUserInfo>(context);
    if (widget.position.latitude != null) {
      _databaseService.updateLocation(widget.position);
    }
    _controller.repeat();
    print("000000000000000000000000000");
    return  StreamProvider.value(
        value: _databaseService.getOnlineUsers(widget.userData),
        child: CustomPaint(painter: CirclePainter(
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
                      return Stack(
                        children: userWidgets(snapshot.data),
                      );
                    } else {
                      print("----------------NODATA_-----------------");
                      return Container(
                        height: 0,
                      );
                    }
                  },
                );
              }),
            ],
          ),
        ),
      );
  }
}