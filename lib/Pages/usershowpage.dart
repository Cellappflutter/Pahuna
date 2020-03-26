import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';

import '../Model/currentuser.dart';

class CustomScroll extends StatefulWidget {
  final UserData requestData;
  final CurrentUserInfo userData;
  CustomScroll({this.userData, this.requestData});
// need both senders and the receivers data userData is of sender and requestData is of receiver
  @override
  State createState() => new CustomScrollState();
}

class CustomScrollState extends State<CustomScroll> {
  double width = 100;
  bool _isClicked = false;
  GlobalKey _scrollableBottomContainer = GlobalKey();
  double imageContainerHeight = ScreenSizeConfig.safeBlockVertical * 60;
  double minIimageContainerHeight = ScreenSizeConfig.safeBlockVertical * 25;
  double maxIimageContainerHeight = ScreenSizeConfig.safeBlockVertical * 80;
  double mininfoContainerHeight = ScreenSizeConfig.safeBlockVertical * 20;
  double maxinfoContainerHeight = ScreenSizeConfig.safeBlockVertical * 75;
  double infoContainerHeight = ScreenSizeConfig.safeBlockVertical * 40;
  List<String> gridImages = [
    "https://i.picsum.photos/id/111/200/300.jpg",
    "https://i.picsum.photos/id/23/200/300.jpg",
    "https://i.picsum.photos/id/13/200/300.jpg",
    "https://i.picsum.photos/id/42/200/300.jpg",
    "https://i.picsum.photos/id/53/200/300.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: new Container(
                  color: Colors.blue,
                  height: imageContainerHeight,
                  child: FutureBuilder(
                    future: StorageService().getAvatar(widget.requestData.uid),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Image(
                            image: CachedNetworkImageProvider(snapshot.data),
                            fit: BoxFit.cover);
                      } else {
                        return Image(image: AssetImage('assets/user3.jpg'));
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    print(_scrollableBottomContainer.currentContext.size);
                    print(infoContainerHeight);
                    imageContainerHeight += (details.delta.dy);
                    infoContainerHeight += (-details.delta.dy);
                    if (imageContainerHeight < (minIimageContainerHeight)) {
                      imageContainerHeight = minIimageContainerHeight;
                      infoContainerHeight = maxinfoContainerHeight;
                    } else if (imageContainerHeight >
                        maxIimageContainerHeight) {
                      imageContainerHeight = maxIimageContainerHeight;
                      infoContainerHeight = mininfoContainerHeight;
                    }
                    setState(() {});
                  },
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(8, 30, 8, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        color: Colors.white),
                    height: infoContainerHeight,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        key: _scrollableBottomContainer,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Stack(
                              alignment: AlignmentDirectional.topStart,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                //Starting of Name and Email
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.requestData.name != null
                                            ? widget.requestData.name
                                            : "Name",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(widget.requestData.email,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                          ))
                                    ],
                                  ),
                                ), //End of Name and Email
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isClicked = true;
                                        width = 40;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      alignment: Alignment.topRight,
                                      duration: Duration(milliseconds: 200),
                                      width: (_isClicked) ? 40 : width,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: (_isClicked)
                                            ? Colors.red
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2, color: Colors.red),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          child: (_isClicked)
                                              ? Icon(UiIcons.user)
                                              : Text(
                                                  'Connect',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.redAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          onTap: () async {
                                            if (!_isClicked) {
                                              await DatabaseService().sendReq(
                                                  widget.requestData
                                                      .uid, // patahuney ko uid and afnoname pathauna parxa
                                                  widget.userData.name);
                                              _isClicked = true;
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.requestData.description,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 19, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Interest',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                              ),
                              //SizedBox(height: 5),
                              Wrap(
                                  spacing: 6.0,
                                  runSpacing: 2.0,
                                  children: _interestChip(
                                      widget.requestData.interest))
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Photos',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: getGridPhotos(gridImages),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    color: Colors.red,
                    icon: Icon(
                      Icons.cancel,
                      // color: Colors.white,
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

  // Widget buildListItem(BuildContext context, int index) {
  //   return new Container(color: Colors.red, child: new Text('Item $index'));
  // }

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

  getGridPhotos(List<String> gridImages) {
    List<Widget> widgets = [];
    for (String image in gridImages) {
      widgets.add(
        Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: image,
              height: 150,
              width: 150,
              fit: BoxFit.fill,
              placeholder: (context, data) {
                return CircularProgressIndicator();
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      );
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
