import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:flutter/services.dart';

import '../../Helper/locationstream.dart' as locationstream;

class Gmaps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Maps();
  }
}

class _Maps extends State<Gmaps> {
  GoogleMapController mapController;

  //final LatLng _center = const LatLng(45.521563, -122.677433);

  String _platformVersion = 'Unknown';

  MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
        
    
      }
    });

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String to = '';

  Location _destination;

  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int i = 0;
    final userData = Provider.of<Position>(context);
    String from =
        userData.latitude.toString() + " ," + userData.longitude.toString();
    final _origin = Location(
        name: "your",
        latitude: userData.latitude,
        longitude: userData.longitude);
    final LatLng _center = LatLng(userData.latitude, userData.longitude);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, 'Map'),
        body: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onTap: (v) {
              final marker = Marker(
                markerId: MarkerId(i.toString()),
                position: LatLng(v.latitude, v.longitude),
              );
              setState(() {
                i = i + 1;
                to = v.latitude.toString() + " ," + v.longitude.toString();
                _destination = Location(
                    name: "Destiantion",
                    latitude: v.latitude,
                    longitude: v.longitude);
                _markers.add(marker);
              });
            },
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 18.0),
            markers: _markers.toSet(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('From')),
                      Padding(
                          padding: EdgeInsets.only(left: 10), child: Text(from))
                    ],
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.05 + 10,
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('To')),
                      Padding(
                          padding: EdgeInsets.only(left: 10), child: Text(to))
                    ],
                  )),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FloatingActionButton(
                child: Text("GO"),
                onPressed: ()async{
                  _destination !=null?
                  await _directions.startNavigation(
                    origin: _origin,
                    destination: _destination,
                    mode: NavigationMode.drivingWithTraffic,
                    simulateRoute: true,
                    language: "German",
                    units: VoiceUnits.metric):null;
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}

