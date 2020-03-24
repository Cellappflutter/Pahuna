import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/Pages/NearbySearch.dart';
import 'package:provider/provider.dart';

import '../Model/currentuser.dart';

class BigMess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Scroll demo',
      home: new Scaffold(
        // appBar: new AppBar(elevation: 1),
        body: new CustomScroll(),
      ),
    );
  }
}

class CustomScroll extends StatefulWidget {
  UserData requestData;
  CurrentUserInfo userData;
  CustomScroll({this.userData, this.requestData});
// need both senders and the receivers data userData is of sender and requestData is of receiver
  @override
  State createState() => new CustomScrollState();
}

class CustomScrollState extends State<CustomScroll> {
  double width = 100;
  bool _isClicked = false;
  GlobalKey _key = GlobalKey();
  // double height = ScreenSizeConfig.safeBlockVertical * 10;
  // double width = ScreenSizeConfig.safeBlockHorizontal * 25;
  ScrollController scrollController;
  double offset = 0.0;
  static const double kEffectHeight = 600.0;

  @override
  Widget build(BuildContext context) {
    // final info = Provider.of<CurrentUserInfo>(context);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
// alignment: AlignmentDirectional.bottomCenter,
            //alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: new Container(
                  key: _key,
                  color: Colors.blue,
                  height:
                      (kEffectHeight - offset * 0.5).clamp(0.0, kEffectHeight),
                  child: FutureBuilder(
                    future: StorageService().getAvatar(widget.requestData.uid),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return
                            // Image.network(snapshot.data, fit: BoxFit.cover);
                            Image(
                                image:
                                    CachedNetworkImageProvider(snapshot.data),
                                fit: BoxFit.cover);
                      } else {
                        return
                            // Image(
                            // image: CachedNetworkImageProvider(
                            //     "http://via.placeholder.com/200x150"
                            //     ),
                            Image.asset('assets/brokenimage.png',
                                fit: BoxFit.cover);
                        // fit: BoxFit.cover
                        // );
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        // 40
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Colors.white),
                  height: (200 + offset * 0.5) * 1,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //Starting of Name and Email
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      widget.requestData.name != null
                                          ? widget.requestData.name
                                              .toUpperCase()
                                          : "Name",
                                      style: TextStyle(
                                        letterSpacing: 1.2,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.white
                                      ),
                                    ),
                                    Text(widget.requestData.email,
                                        style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          // color: Colors.white
                                        ))
                                  ],
                                ),
                              ), //End of Name and Email
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isClicked = true;
                                    width = 40;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  width: (_isClicked) ? 40 : width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: (_isClicked)
                                        ? Colors.red
                                        : Colors.white,
                                    border:
                                        Border.all(width: 2, color: Colors.red),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      child: (_isClicked)
                                          ? Icon(Icons.check)
                                          : Text(
                                              'FOLLOW',
                                              style: TextStyle(
                                                  letterSpacing: 1.2,
                                                  fontSize: 15,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      onTap: () {
                                        setState(() {
                                          _isClicked = true;
                                        });
                                        DatabaseService().sendReq(
                                            widget.requestData
                                                .uid, // patahuney ko uid and afnoname pathauna parxa
                                            widget.userData.name);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          child: Container(color: Colors.grey),
                          width: 600,
                          height: 1,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.requestData.description,
                              style: TextStyle(
                                height: 1.4,
                                letterSpacing: 1,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          child: Container(color: Colors.grey),
                          width: 400,
                          height: 1,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'INTEREST',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                              ),
                              SizedBox(height: 15),
                              Wrap(
                                  spacing: 6.0,
                                  runSpacing: 2.0,
                                  alignment: WrapAlignment.spaceEvenly,
                                  children: _interestChip(
                                      widget.requestData.interest))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    return new Container(color: Colors.red, child: new Text('Item $index'));
  }

  List<Widget> _interestChip(List<dynamic> interest) {
    List<Widget> widget = List<Widget>();
    for (int i = 0; i < interest.length; i++) {
      Widget w = StatefulBuilder(builder: (BuildContext context, setState) {
        return Container(
          child: Chip(
            backgroundColor: Colors.purple,
            label: Text(
              interest[i],
              style: TextStyle(
                letterSpacing: 1.2,
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      });
      widget.add(w);
    }
    return widget;
  }

  void updateOffset() {
    setState(() {
      offset = scrollController.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(updateOffset);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(updateOffset);
  }
}
