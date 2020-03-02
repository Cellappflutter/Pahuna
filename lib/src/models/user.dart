import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

enum UserState { available, away, busy }

class User {
  String id = UniqueKey().toString();
  String name;
  String email;
  String gender;
  DateTime dateOfBirth;
  String avatar;
  String address;
  UserState userState;

  User.init();

  User.basic(this.name, this.avatar, this.userState);

  User.advanced(this.name, this.email, this.gender, this.dateOfBirth, this.avatar, this.address, this.userState);

  User getCurrentUser() {
    return User.advanced('Andrew R. Whitesides', 'andrew@gmail.com', 'Male', DateTime(1993, 12, 31), 'img/user2.jpg',
        '4600 Isaacs Creek Road Golden, IL 62339', UserState.available);
  }

  getDateOfBirth() {
    return DateFormat('yyyy-MM-dd').format(this.dateOfBirth);
  }
}

                  //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.circular(6),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color:
                  //               Theme.of(context).hintColor.withOpacity(0.15),
                  //           offset: Offset(0, 3),
                  //           blurRadius: 10)
                  //     ],
                  //   ),
                  //   child: ListView(
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     children: <Widget>[
                  //       ListTile(
                  //         // leading: Icon(UiIcons.user_1),
                  //         // title: Text(
                  //         //   'Profile Settings',
                  //         //   style: Theme.of(context).textTheme.body2,
                  //         // ),
                  //         title:Row(children: <Widget>[
                  //           Icon(UiIcons.user_1),
                  //           SizedBox(width:10),
                  //           Text("Profile Settings",
                  //           style: Theme.of(context).textTheme.body2)
                  //         ],),
                  //       ),
                  //       ListTile(
                  //         onTap: () {},
                  //         dense: true,
                  //         title: Row(
                  //           children: <Widget>[
                  //             Icon(
                  //               UiIcons.placeholder,
                  //               size: 22,
                  //               color: Theme.of(context).focusColor,
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text(
                  //               'Shipping Adresses',
                  //               style: Theme.of(context).textTheme.body1,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       ListTile(
                  //         onTap: () {
                  //           Navigator.of(context).pushNamed('/Languages');
                  //         },
                  //         dense: true,
                  //         title: Text(
                  //           'Age',
                  //           style: Theme.of(context).textTheme.body1,
                  //         ),
                  //         trailing: Container(
                  //           width: ScreenSizeConfig.safeBlockHorizontal * 50,
                  //           child: TextFormField(
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText: 'Age',
                  //             ),
                  //             keyboardType: TextInputType.number,
                  //             textDirection: TextDirection.rtl,
                  //             textAlign: TextAlign.right,
                  //             enabled: edit,
                  //             validator: (value) {
                  //               if (int.parse(value) >= 18) {
                  //                 widget.userInfo.age = int.parse(value);
                  //                 return null;
                  //               }
                  //             },
                  //             initialValue: widget.userInfo.age.toString(),
                  //             style: TextStyle(
                  //                 color: Theme.of(context).focusColor),
                  //           ),
                  //         ),
                  //       ),
                  //       ListTile(
                  //         onTap: () {},
                  //         dense: true,
                  //         title: (Text(
                  //           'Email',
                  //           style: Theme.of(context).textTheme.body1,
                  //         )),
                  //         trailing: Text(
                  //             (widget.userInfo.email != null)
                  //                 ? widget.userInfo.email
                  //                 : "email here...",
                  //             style: TextStyle(
                  //                 color: Theme.of(context).focusColor)),
                  //       ),
                  //       // ListTile(
                  //       //   onTap: () {},
                  //       //   dense: true,
                  //       //   title: Text(
                  //       //     'Match Preferences',
                  //       //     style: Theme.of(context).textTheme.body1,
                  //       //   ),
                  //       //   trailing: Text(
                  //       //     widget.userInfo.matchPrefs.toString(),
                  //       //     // _user.getDateOfBirth()                          ,
                  //       //     style:
                  //       //         TextStyle(color: Theme.of(context).focusColor),
                  //       //   ),
                  //       // ),
                  //       // ListTile(
                  //       //   onTap: () {},
                  //       //   dense: true,
                  //       //   title: Text(
                  //       //     'Continent',
                  //       //     style: Theme.of(context).textTheme.body1,
                  //       //   ),
                  //       //   trailing: Text(
                  //       //     widget.userInfo.continent.toString(),
                  //       //     style:
                  //       //         TextStyle(color: Theme.of(context).focusColor),
                  //       //   ),
                  //       // )
                  //     ],
                  //   ),
                  // ),
