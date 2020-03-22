import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/Pages/NearbySearch.dart';

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
  UserData userData;
  CustomScroll({this.userData});

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
                    future: StorageService().getAvatar(widget.userData.uid),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return
                            // Image.network(snapshot.data, fit: BoxFit.cover);
                            Image(
                                image:
                                    CachedNetworkImageProvider(snapshot.data),
                                fit: BoxFit.cover);
                      } else {
                        return Image.asset('assets/user3.jpg',
                            fit: BoxFit.cover);
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
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
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
                          margin: EdgeInsets.only(top: 50),
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
                                      widget.userData.name != null
                                          ? widget.userData.name
                                          : "Name",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.white
                                      ),
                                    ),
                                    Text(widget.userData.email,
                                        style: TextStyle(
                                          fontSize: 18,
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
                                  duration: Duration(seconds: 1),
                                  width: width,
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
                                                  fontSize: 15,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      onTap: () {
                                        DatabaseService().sendReq(
                                            widget.userData.uid,
                                            widget.userData.name);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.userData.description,
                              style: TextStyle(
                                  fontSize: 19, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Interest',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                              ),
                              SizedBox(height: 15),
                              Wrap(
                                  spacing: 6.0,
                                  runSpacing: 2.0,
                                  alignment: WrapAlignment.spaceEvenly,
                                  children:
                                      _interestChip(widget.userData.interest))
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
                color: Colors.white,
                fontSize: 18,
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
