import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/account.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, 'Profile'),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Wrap(children: <Widget>[
                  Container(
                      // height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context){
                                      return Dialog(
                                        child:Container(
                                          child: CachedNetworkImage(
                                            imageUrl: widget.editableInfo.avatar,
                                            placeholder: (context,url) => CircularProgressIndicator(),
                                          ),
                                        )
                                      );
                                    }
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.editableInfo.avatar,
                                  ),
                                  radius: 70,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    print('Edit pressed');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AccountWidget(
                                                  userInfo: widget.editableInfo,
                                                  tutorialShow: false,
                                                )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Text(widget.editableInfo.name,
                          style: Theme.of(context).textTheme.display3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person_pin_circle,
                            color: Theme.of(context).accentColor,
                            size: 20,
                          ),
                          Text(
                            'Pepsicola-35, Kathmandu',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w100,
                                fontSize: 13,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Text(
                        widget.editableInfo.email,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 8),
                        child: Text(
                          widget.editableInfo.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ],
                  )),
                ]),

                SizedBox(
                  height: 10,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Center(
                      child: _followercard(),
                    )),

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
                  child: ListView(
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
                        title: Text("Continent",
                            style: Theme.of(context).textTheme.body1),
                        subtitle: Wrap(
                          spacing: 5,
                          children: getChips(widget.editableInfo.continent,
                              ProfileContinentPreferences().colors),
                        ),
                      ),
                      ListTile(
                        dense: false,
                        title: Text("Interest",
                            style: Theme.of(context).textTheme.body1),
                        subtitle: Wrap(
                          spacing: 5,
                          children: getChips(widget.editableInfo.interest,
                              ProfileInterestPreferences().colors),
                        ),
                      )
                    ],
                  ),
                ),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5.0,
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
}
