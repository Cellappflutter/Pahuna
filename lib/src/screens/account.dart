import 'dart:io';

import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountWidget extends StatefulWidget {
  final CurrentUserInfo userInfo;
  AccountWidget({this.userInfo});
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  // User _user = new User.init().getCurrentUser();
  File _image;
  bool _isLocalImage = false;
  @override
  Widget build(BuildContext context) {
    print("-------------");
    print(widget.userInfo.name);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.userInfo.name,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.display2,
                            ),
                            Text(
                              "umesh@example.com",
                              // widget.userInfo.email,
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(
                          width: 55,
                          height: 55,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              onTap: () async {
                                await avatarPicker();
                              },
                              child: (_isLocalImage)
                                  ? ((_image != null)
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(_image),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.red,
                                        ))
                                  : ((widget.userInfo.avatar != "" &&
                                          widget.userInfo.avatar != null)
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.userInfo.avatar),
                                        )
                                      : CircleAvatar()))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.15),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/Tabs', arguments: 4);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(UiIcons.heart),
                              Text(
                                'Wish List',
                                style: Theme.of(context).textTheme.body1,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/Tabs', arguments: 0);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(UiIcons.favorites),
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.body1,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/Tabs', arguments: 3);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(UiIcons.chat_1),
                              Text(
                                'Messages',
                                style: Theme.of(context).textTheme.body1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.15),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(UiIcons.user_1),
                        title: Text(
                          'Profile Settings',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Text(
                          'Full name',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        trailing: Text(
                          widget.userInfo.name,
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Text(
                          'Gender',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        trailing: Text(
                          widget.userInfo.gender,
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Text(
                          'Interest',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        trailing: Text(
                          widget.userInfo.interest.toString(),
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Text(
                          'Match Preferences',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        trailing: Text(
                          widget.userInfo.matchPrefs.toString(),
                          // _user.getDateOfBirth()                          ,
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Text(
                          'Continent',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        trailing: Text(
                          widget.userInfo.continent.toString(),
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.15),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(UiIcons.settings_1),
                        title: Text(
                          'Account Settings',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              UiIcons.placeholder,
                              size: 22,
                              color: Theme.of(context).focusColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Shipping Adresses',
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Languages');
                        },
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              UiIcons.planet_earth,
                              size: 22,
                              color: Theme.of(context).focusColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Languages',
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ],
                        ),
                        trailing: Text(
                          'English',
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Help');
                        },
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              UiIcons.information,
                              size: 22,
                              color: Theme.of(context).focusColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Help & Support',
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ],
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
    );
  }

  avatarPicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        _isLocalImage = true;
      });
    }
    await uploadAvatar(context);
  }

  uploadAvatar(BuildContext context) async {
    try {
      String fileName = _image.path.split('/').removeLast();
      print(fileName);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(DatabaseService.uid)
          .child("avatar.jpg");
      StorageUploadTask task = storageReference.putFile(_image);
      await task.onComplete;
      print("UPLOADED");
    } catch (e) {
      print(e);
    }
  }
}