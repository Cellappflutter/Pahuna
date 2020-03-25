import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/constant.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
//  final UserInfo userInfo;
  //Profile(this.userInfo);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Icon customIcon = Icon(Icons.search);
  Widget customSearch = Text('Profile Test');

  final profilePic = new Container(
    // margin: new EdgeInsets.only(
    //   left: ScreenSizeConfig.blockSizeVertical * 5,
    // ),
    child: CircleAvatar(
      radius: 70.0,
      backgroundColor: Colors.blue,
      // backgroundImage: AssetImage(userInfo[1].image),
    ),
  );

  final profileCard = new Container(
    margin: new EdgeInsets.fromLTRB(
        ScreenSizeConfig.blockSizeVertical * 2, 90.0, 15.0, 60.0),
    decoration: new BoxDecoration(
        color: Color(0x61000000),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(50.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black38,
            blurRadius: 5.0,
            offset: new Offset(9.0, 9.0),
          )
        ]),
  );

  final profileCardDetail = new Container(
    margin: EdgeInsets.fromLTRB(75.0, ScreenSizeConfig.safeBlockHorizontal, 10.0, 10.0),
    constraints: BoxConstraints.expand(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 4.0,
        ),
        Text(
          "Name",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 30.0,
              child: Icon(Icons.location_on),
            ),
            Text(
              "Location",
              style: TextStyle(
                color: Colors.black45,
                fontSize: AppColors.fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.redAccent,
          ),
          // width: MediaQuery.of(context).size.width,
          child: Text("Description"),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUserInfo>(
      builder: (context, userInfo, child) {
        if (userInfo != null) {
          return FutureBuilder(
            future: StorageService().getUserAvatar(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                // Navigator.pop(context);
                userInfo.avatar = snapshot.data;
              }
              return Container(
              
                height: AppColors.pageheight,
               
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          color: Color(0x61000000),
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(50.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5.0,
                              offset: new Offset(9.0, 9.0),
                            )
                          ]),
                    ),
                  
                    profilePic,
                      profileCardDetail,

                    RaisedButton(onPressed: () {

                    }),

                    Column(
                      children: <Widget>[
                        Text(
                          userInfo.name.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                        Text(
                          userInfo.age.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                        Text(
                          userInfo.gender.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                        Text(
                          userInfo.interest.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                        Text(
                          userInfo.continent.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                         Text(
                          userInfo.matchPrefs.toString(),
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 20),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              );
            },
          );
        } else {
          return Text("Loading Data");
        }
      },
    );
  }
}
