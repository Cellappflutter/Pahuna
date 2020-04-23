import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Pages/friends.dart';
import 'package:ecommerce_app_ui_kit/Pages/photos.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:help/data.dart';

class Profile extends StatefulWidget {
  final CurrentUserInfo editableInfo;

  const Profile({Key key, this.editableInfo}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _profile();
  }
}

class _profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: customAppBar(context, 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TopContainer(
                editableInfo: widget.editableInfo,
                ccontext: context,
              ),

              Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Center(
                    child: _followercard(),
                  )),
              coolrow(),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10),
                  ],
                ),
                child: preferencelist(),
              ),
              Text("Your Places",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('img/italy.png'),
                  radius: 30,
                ),
                title: Text("Italy"),
                subtitle: Text("You've been to Italy WOW"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('img/brazil.png'),
                  radius: 30,
                ),
                title: Text("Brazil"),
                subtitle: Text("You've been to Brazil WOW"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('img/china.png'),
                  radius: 30,
                ),
                title: Text("China"),
                subtitle: Text("You've been to China....WOW good luck with that"),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('img/canada.png'),
                  radius: 30,
                ),
                title: Text("Canada"),
                subtitle: Text("You've been to Canada WOW"),
              )

              // Container(
              //   height: 438,
              //     margin: EdgeInsets.only(top: 5),
              //     decoration: BoxDecoration(
              //       backgroundBlendMode: BlendMode.color,
              //        color: Colors.black12,
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(20),
              //             topRight: Radius.circular(20))),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
              //       child: StaggeredGridView.countBuilder(
              //         crossAxisCount: 4,
              //         itemCount: images.length,
              //         itemBuilder: (BuildContext context, index) {
              //          return Container(
              //             decoration: BoxDecoration(
              //               color: Colors.black,
              //               borderRadius: BorderRadius.all(Radius.circular(20)),
              //                 image: DecorationImage(
              //                     image: AssetImage(images[index]),
              //                     fit: BoxFit.fill)),
              //           );
              //         },
              //         staggeredTileBuilder: (int index) =>
              //             StaggeredTile.count(2, index.isEven ? 2 : 4),
              //         mainAxisSpacing: 4.0,
              //         crossAxisSpacing: 4.0,
              //       ),
              //     )),
            ],
          ),
        ),
      ),
    );
  }

  getChips(List<dynamic> chips, List<int> chipsColor) {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < chips.length; i++) {
      widgets.add(
        ChoiceChip(
          labelStyle: TextStyle(color: Colors.black),
          label: Text(
            chips[i],
          ),
          selected: true,
          selectedColor: Color(chipsColor[i]),
        ),
      );
    }
    return widgets;
  }

  _followercard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.15),
              offset: Offset(0, 3),
              blurRadius: 10),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 50,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Followers',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                      ))),
                  Container(
                      height: 20,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text('35',
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor)),
                      ))),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 50,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Following',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                      ))),
                  Container(
                      height: 20,
                      child: Center(
                          child: Text('35',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor)))),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 50,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Pictures',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                      ))),
                  Container(
                      height: 20,
                      child: Center(
                          child: Text('35',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  preferencelist() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(UiIcons.loupe),
              SizedBox(width: 10),
              Text(
                "Your Preferences",
              )
            ],
          ),
        ),
        ListTile(
          dense: true,
          title: Text("Match Preferences",
              style: Theme.of(context).textTheme.body1),
          subtitle: Wrap(
            spacing: 5,
            children: getChips(widget.editableInfo.matchPrefs,
                ProfileMatchPreferences().colors),
          ),
        ),
        ListTile(
          dense: true,
          title: Text("Continent", style: Theme.of(context).textTheme.body1),
          subtitle: Wrap(
            spacing: 5,
            children: getChips(widget.editableInfo.continent,
                ProfileContinentPreferences().colors),
          ),
        ),
        ListTile(
          dense: false,
          title: Text("Interest", style: Theme.of(context).textTheme.body1),
          subtitle: Wrap(
            spacing: 5,
            children: getChips(widget.editableInfo.interest,
                ProfileInterestPreferences().colors),
          ),
        )
      ],
    );
  }

  coolrow() {
    return Container(
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //  height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountWidget(
                            userInfo: widget.editableInfo,
                            tutorialShow: false,
                          )));
            },
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.black12,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      size: 40,
                      color: Theme.of(context).accentColor,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FriendsWidget(
                          tag: "Profile",
                        )));
              },
              child: CircleAvatar(
                radius: 65.0,
                backgroundColor: Colors.black12,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(UiIcons.users,
                          size: 40, color: Theme.of(context).accentColor),
                      Text(
                        'Friends',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPhotos(
                        userId: widget.editableInfo.uid,
                      )));
            },
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.black12,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      UiIcons.image,
                      size: 40,
                      color: Theme.of(context).accentColor,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MineCLipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.7);
    // path.addOval(Rect.fromCircle())
    path.quadraticBezierTo(
        size.width * 0.4, size.height, size.width, size.height * 0.9);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class TopContainer extends StatefulWidget {
  final CurrentUserInfo editableInfo;
  final BuildContext ccontext;
  TopContainer({
    Key key,
    this.editableInfo,
    this.ccontext,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _topContainer();
  }
}

class _topContainer extends State<TopContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Dialog(
                          child: Container(
                        child: CachedNetworkImage(
                          imageUrl: widget.editableInfo.avatar,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        ),
                      ));
                    });
              },
              child: ClipPath(
                clipper: MineCLipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.editableInfo.avatar),
                          fit: BoxFit.cover)),
                ),
              ),
              // child: Container(
              //   height: MediaQuery.of(context).size.height*0.4,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: NetworkImage(
              //               widget.editableInfo.avatar),fit: BoxFit.cover)),
              // ),
              // child: CircleAvatar(
              //   backgroundImage: CachedNetworkImageProvider(
              //     widget.editableInfo.avatar,
              //   ),
              //radius: 70,
              // ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Theme.of(widget.ccontext).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(widget.ccontext)
                            .hintColor
                            .withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10),
                  ],
                ),
                child: Wrap(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(widget.editableInfo.name,
                          style: Theme.of(widget.ccontext).textTheme.display3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person_pin_circle,
                            color: Theme.of(widget.ccontext).accentColor,
                            size: 20,
                          ),
                          Text(
                            'Pepsicola-35, Kathmandu',
                            style: TextStyle(
                                color: Theme.of(widget.ccontext).accentColor,
                                fontWeight: FontWeight.w100,
                                fontSize: 13,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Text(
                        widget.editableInfo.email,
                        style: TextStyle(
                            color: Theme.of(widget.ccontext).accentColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 8),
                        child: Text(
                          widget.editableInfo.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(widget.ccontext).textTheme.body2,
                        ),
                      ),
                    ],
                  ),
                ])),
          )
        ],
      ),
    ));
  }
}
