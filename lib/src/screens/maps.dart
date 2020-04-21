import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geodesy/geodesy.dart' as geo;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/src/material/animated_icons.dart';

import 'package:flutter/services.dart';

import '../../Helper/locationstream.dart' as locationstream;

class Gmaps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Maps();
  }
}

// class _Maps extends State<Gmaps> with TickerProviderStateMixin {
//   MapController mapController = MapController();
//   AnimationController animationController;
//   String _platformVersion = 'Unknown';
//   bool scrollVisible = true;

//   MapboxNavigation _directions;
//   bool _arrived = false;
//   double _distanceRemaining, _durationRemaining;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 4));
//     animationController.forward();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     _directions = MapboxNavigation(onRouteProgress: (arrived) async {
//       _distanceRemaining = await _directions.distanceRemaining;
//       _durationRemaining = await _directions.durationRemaining;

//       setState(() {
//         _arrived = arrived;
//       });
//       if (arrived) {
//         await Future.delayed(Duration(seconds: 3));
//         await _directions.finishNavigation();
//       }
//     });

//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await _directions.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   void _onMapCreated(MapController controller) {
//     mapController = controller;
//   }

//   var points = <LatLng>[
//     LatLng(27.694729, 85.320307),
//     LatLng(27.694834, 85.320477),
//     LatLng(27.694834, 85.320692),
//     LatLng(27.694683, 85.320796),
//     LatLng(27.694512, 85.320781),
//     LatLng(27.694223, 85.320759),
//     LatLng(27.694013, 85.32096),
//     LatLng(27.693842, 85.321249),
//     LatLng(27.693652, 85.321687),
//     LatLng(27.692532, 85.324061),
//     LatLng(27.690209, 85.328587),
//     LatLng(27.690274, 85.328485),
//     LatLng(27.689459, 85.330548),
//     LatLng(27.689012, 85.33244),
//     LatLng(27.688335, 85.335482),
//     LatLng(27.688329, 85.335545),
//     LatLng(27.690474, 85.336002),
//     LatLng(27.690453, 85.336358),
//     LatLng(27.690639, 85.33636),
//   ];

//   String to = '';
//   LatLng routestart= LatLng(27.694729, 85.320307);
//   bool _showroute = false;

//   List<Marker> _markers = [Marker(), Marker()];
//   Location _destination;

//   @override
//   Widget build(BuildContext context) {
//     final userData = Provider.of<Position>(context);
//     String from =
//         userData.latitude.toString() + " ," + userData.longitude.toString();
//     final _origin = Location(
//         name: "your",
//         latitude: userData.latitude,
//         longitude: userData.longitude);

//     _markers[0] = (Marker(
//       point: new LatLng(userData.latitude, userData.longitude),
//       builder: (ctx) => new Container(
//         child: Icon(Icons.my_location, color: Colors.blueAccent),
//       ),
//     ));
//     // TODO: implement build
//     ;
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             FlutterMap(
//               mapController: mapController,
//               options: MapOptions(

//                   center: LatLng(userData.latitude, userData.longitude),
//                   zoom: 18.0,
//                   debug: true,
//                   maxZoom: 18.0,
//                   onTap: (c) {
//                     setState(() {
//                       _markers[1] = (Marker(
//                         point: new LatLng(c.latitude, c.longitude),
//                         builder: (ctx) => new Container(
//                           child: Icon(
//                             Icons.location_on,
//                             color: Colors.redAccent,
//                           ),
//                         ),
//                       ));
//                       to =
//                           c.latitude.toString() + " ," + c.longitude.toString();
//                       _destination = Location(
//                           name: "Destiantion",
//                           latitude: c.latitude,
//                           longitude: c.longitude);
//                     });
//                   }),
//               layers: [
//                 new TileLayerOptions(
//                   urlTemplate: "https://api.mapbox.com/v4/"
//                       "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
//                   additionalOptions: {
//                     'accessToken':
//                         'sk.eyJ1IjoiY2VsbGFwcCIsImEiOiJjazh6bWw0eGkxam1sM3JvN3ZqbGQ2cDd6In0.TrrWnAdBk0b_ZtgCv9qV_Q',
//                     'id': 'mapbox.streets',
//                   },
//                 ),
//                 new MarkerLayerOptions(
//                   markers: _markers,
//                 ),
//                 PolylineLayerOptions(
//                     polylines: _showroute == true
//                         ? [
//                             Polyline(
//                                 points: points,
//                                 strokeWidth: 5.0,
//                                 color: Colors.amber),
//                           ]
//                         : [])
//               ],
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: EdgeInsets.all(5),
//                 child: Container(
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white),
//                     child: Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text('From')),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(from))
//                       ],
//                     )),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height * 0.05 + 10,
//                 ),
//                 child: Container(
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white),
//                     child: Row(
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text('To')),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10), child: Text(to))
//                       ],
//                     )),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: InkWell(
//                   onTap: () async {
//                     _destination != null
//                         ? await _directions.startNavigation(
//                             origin: _origin,
//                             destination: _destination,
//                             mode: NavigationMode.drivingWithTraffic,
//                             simulateRoute: true,
//                             language: "English",
//                             units: VoiceUnits.metric)
//                         : null;
//                   },
//                   splashColor: Colors.blueAccent,
//                   child: ClipOval(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.08,
//                       width: MediaQuery.of(context).size.height * 0.08,
//                       color: Colors.red,
//                       child: Center(
//                           child: Text(
//                         'GO',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: FlatButton.icon(
//                   label: Text('you'),
//                   icon: Icon(Icons.gps_fixed),
//                   onPressed: (){
//                   mapController.move(LatLng(userData.latitude, userData.longitude),18);
//                 },)
//               ),
//             )
//           ],
//         ),
//         floatingActionButton: boomMenu(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     animationController.dispose();

//   }

//   BoomMenu boomMenu() {
//     return BoomMenu(
//         animatedIcon: AnimatedIcons.menu_close,
//         animatedIconTheme: IconThemeData(size: 22.0),
//         //child: Icon(Icons.add),
//         onOpen: () => print('OPENING DIAL'),
//         onClose: () => print('DIAL CLOSED'),
//         scrollVisible: scrollVisible,
//         overlayColor: Colors.black,
//         overlayOpacity: 0.7,
//         children: [
//           MenuItem(
//             child: Icon(
//               Icons.accessibility,
//               color: Colors.black,
//             ),
// //          child: Image.asset('assets/logout_icon.png', color: Colors.grey[850]),
//             title: "Custom Routes",
//             titleColor: Colors.grey[850],
//             subtitle: "These are the custom routes we have for you",
//             subTitleColor: Colors.grey[850],
//             backgroundColor: Colors.grey[50],
//             onTap: () => print('THIRD CHILD'),
//           ),
//           MenuItem(
//             child: Icon(Icons.directions_run),
//             title: "Route 1",
//             titleColor: Colors.white,
//             subtitle: "From Maitighar to RBB Baneshwer",
//             subTitleColor: Colors.white,
//             backgroundColor: _showroute? Colors.pinkAccent:Colors.purple,
//             onTap: () {
//               setState(() {
//                 _showroute ? _showroute = false : _showroute = true;
//                 mapController.move(routestart, 15);
//                // mapController.rotate(30);
//               });
//             },
//           ),
//         ]);
//   }
// }

class _Maps extends State<Gmaps> {
  GoogleMapController mapController;

  //final LatLng _center = const LatLng(45.521563, -122.677433);
  bool scrollVisible = true;
  bool _showroute = false;
  String _platformVersion = 'Unknown';
  LatLng routestart = LatLng(27.694729, 85.320307);

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

  static List<LatLng> points = [
    LatLng(27.694729, 85.320307),
    LatLng(27.694834, 85.320477),
    LatLng(27.694834, 85.320692),
    LatLng(27.694683, 85.320796),
    LatLng(27.694512, 85.320781),
    LatLng(27.694223, 85.320759),
    LatLng(27.694013, 85.32096),
    LatLng(27.693842, 85.321249),
    LatLng(27.693652, 85.321687),
    LatLng(27.692532, 85.324061),
    LatLng(27.690209, 85.328587),
    LatLng(27.690274, 85.328485),
    LatLng(27.689459, 85.330548),
    LatLng(27.689012, 85.33244),
    LatLng(27.688335, 85.335482),
    LatLng(27.688329, 85.335545),
    LatLng(27.690474, 85.336002),
    LatLng(27.690453, 85.336358),
    LatLng(27.690639, 85.33636)
  ];

  static List<LatLng> points1 = [
    LatLng( 27.69151,85.32048,),
    LatLng( 27.69136,85.32103,),
    LatLng( 27.69125,85.32098,),
    LatLng( 27.69092,85.32089,),
    LatLng( 27.69074,85.32083,),
    LatLng( 27.69071,85.32082,),
    LatLng(27.69066,85.3208) ,
    LatLng( 27.6906,85.32079),
    LatLng( 27.69056,85.32078),
    LatLng( 27.69053,85.32078,),
    LatLng( 27.69052,85.32079,),
    LatLng(27.6905,85.3208), 
    LatLng( 27.69048,85.32083,),
    LatLng( 27.69045,85.32089,),
    LatLng( 27.6904,85.32103),
    LatLng( 27.69039,85.32105,),
    LatLng( 27.69039,85.32107,),
    LatLng( 27.6904,85.32109),
    LatLng( 27.69041,85.32111,),
    LatLng( 27.69044,85.32119,),
    LatLng( 27.69045,85.32123,),
    LatLng( 27.69049,85.32127,),
    LatLng(27.69053,85.3213,) ,
    LatLng( 27.69058,85.32133,),
    LatLng( 27.69055,85.32141,),
    LatLng( 27.69051,85.32153,),
    LatLng( 27.69049,85.32163,),
    LatLng( 27.69037,85.32201,),
    LatLng( 27.69028,85.32233,),
    LatLng( 27.69019,85.32263,),
    LatLng(27.69017,85.3227),
    LatLng( 27.69005,85.32315,),
    LatLng( 27.69002,85.32326,),
    LatLng( 27.69,85.32337,),
    LatLng(27.69,85.3234,),
    LatLng(27.69, 85.32342,),
    LatLng( 27.69,85.32343,),
    LatLng( 27.69002,85.32345,),
    LatLng( 27.69004,85.32347,),
    LatLng( 27.69005,85.32348,),
    LatLng( 27.69007,85.32349,),
    LatLng( 27.69013,85.32351,),
    LatLng(27.6902,85.32353),
    LatLng( 27.69023,85.32354,),
    LatLng( 27.69035,85.32357,),
    LatLng( 27.69053,85.32363,),
    LatLng( 27.69086,85.32374,),
    LatLng( 27.69091,85.32362,),
    LatLng( 27.69094,85.32356,),
    LatLng( 27.69098,85.32349,),
    LatLng( 27.69102,85.32345,),
    LatLng( 27.69105,85.32344,),
    LatLng( 27.69107,85.32343,),
    LatLng(27.6911,85.32343),
    LatLng( 27.69113,85.32343,),
    LatLng( 27.69125,85.32348,),
    LatLng( 27.69159,85.32358,),
    LatLng( 27.69183,85.32367,),
    LatLng( 27.69217,85.32375,),
    LatLng(27.6924,85.32381),
    LatLng( 27.69167,85.32533,),
    LatLng( 27.69124,85.32623,),
    LatLng( 27.69109,85.32655,),
 ];

  List<Polyline> _polylines = [
    Polyline(
        polylineId: PolylineId('one'),
        startCap: Cap.roundCap,
        points: points,
        jointType: JointType.bevel,
        width: 5),
    Polyline(
        polylineId: PolylineId('two'),
        startCap: Cap.roundCap,
        points: points1,
        jointType: JointType.bevel,
        width: 5),
        
  ];
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
              print(i);
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
            polylines: _showroute ? _polylines.toSet() : null,
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
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: EdgeInsets.all(10),
          //     child: FloatingActionButton(
          //       child: Text("GO"),
          //       onPressed: ()async{

          //         _destination !=null?
          //         await _directions.startNavigation(
          //           origin: _origin,
          //           destination: _destination,
          //           mode: NavigationMode.drivingWithTraffic,
          //           simulateRoute: true,
          //           language: "German",
          //           units: VoiceUnits.metric):null;
          //       },
          //     ),
          //   ),
          // )
        ]),
        floatingActionButton: boomMenu(),
      ),
    );
  }

  BoomMenu boomMenu() {
    return BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        //child: Icon(Icons.add),
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        scrollVisible: scrollVisible,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: [
          MenuItem(
            child: Icon(
              Icons.accessibility,
              color: Colors.black,
            ),
//          child: Image.asset('assets/logout_icon.png', color: Colors.grey[850]),
            title: "Custom Routes",
            titleColor: Colors.grey[850],
            subtitle: "These are the custom routes we have for you",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[50],
            onTap: () => print('THIRD CHILD'),
          ),
          MenuItem(
            child: Icon(Icons.directions_run),
            title: "Route 1",
            titleColor: Colors.white,
            subtitle: "From Maitighar to RBB Baneshwer",
            subTitleColor: Colors.white,
            backgroundColor: _showroute ? Colors.pinkAccent : Colors.purple,
            onTap: () {
              setState(() {
                _showroute ? _showroute = false : _showroute = true;
                mapController.animateCamera(CameraUpdate.newLatLng(routestart));
               // mapController.setMapStyle(mapStyle)
              });
            },
          ),
        ]);
  }
}
