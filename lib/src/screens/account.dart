import 'dart:io';

import 'package:ecommerce_app_ui_kit/Helper/UiHelper/customdialog.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:ecommerce_app_ui_kit/src/screens/tabs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  bool edit = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _genderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("-------------");
    print(widget.userInfo.name);
    _genderController.text = widget.userInfo.gender;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, "Profile"),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                (widget.userInfo.name != null)
                                    ? ("widget.userInfo.name")
                                    : ("Your Name"),
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
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: InkWell(
                            onTap: () async {
                              ProgressDialog pr =
                                  loadingBar(context, "Updating Information");
                              if (edit == true) {
                                if (_formKey.currentState.validate()) {
                                  pr.show();
                                  await DatabaseService()
                                      .updateUserProfile(widget.userInfo);
                                  await uploadAvatar(context);
                                  pr.dismiss();
                                }
                              }
                              setState(() {
                                edit = !edit;
                              });
                              print("edit : $edit");
                            },
                            child: edit == false
                                ? Container(
                                    child: Column(children: <Widget>[
                                    Icon(UiIcons.edit),
                                    Text('Edit',
                                        style:
                                            Theme.of(context).textTheme.body1)
                                  ]))
                                : Container(
                                    child: Column(
                                      children: <Widget>[
                                        Icon(UiIcons.safebox),
                                        Text(
                                          'Save',
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        )
                                      ],
                                    ),
                                  ),
                          )),
                          Expanded(
                              child: InkWell(
                                  onTap: () {
                                    if (edit == true) {
                                      return null;
                                    } else {
                                      print("This is from Following" +
                                          widget.userInfo.gender.toString());
                                    }
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Icon(UiIcons.favorites),
                                        Text("Following",
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1),
                                      ],
                                    ),
                                  ))),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (edit == true) {
                                  return null;
                                } else {
                                  print("This is from message $edit");
                                }
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Icon(UiIcons.chat_1),
                                    Text('Messages',
                                        style:
                                            Theme.of(context).textTheme.body1)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: Form(
                      key: _formKey,
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
                            trailing: Container(
                              width: ScreenSizeConfig.safeBlockHorizontal * 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Full Name',
                                ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                enabled: edit,
                                validator: (value) {
                                  widget.userInfo.name = value;
                                  return null;
                                },
                                // enabled: edit,
                                initialValue: widget.userInfo.name,
                                //1 widget.userInfo.name,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                          ),
                          ListTile(
                            enabled: edit,
                            onTap: () async {
                              await genderDialog();
                              setState(() {});
                            },
                            dense: true,
                            title: Text(
                              'Gender',
                              style: Theme.of(context).textTheme.body1,
                            ),
                            trailing: Container(
                              width: ScreenSizeConfig.safeBlockHorizontal * 50,
                              child: Text(
                                widget.userInfo.gender,
                                // controller: _genderController,
                                // decoration: InputDecoration(
                                //   border: InputBorder.none,
                                //   hintText: 'Gender',
                                // ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,

                                //    enabled: edit,
                                // validator: (value) {
                                //   if (value == "Male" ||
                                //       value == "Female" ||
                                //       value == "Others") {
                                //     widget.userInfo.gender = value;

                                //     return null;
                                //   } else
                                //     return "Invalid Gender";
                                // },
                                // //   initialValue: widget.userInfo.gender,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              'Age',
                              style: Theme.of(context).textTheme.body1,
                            ),
                            trailing: Container(
                              width: ScreenSizeConfig.safeBlockHorizontal * 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Age',
                                ),
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                enabled: edit,
                                validator: (value) {
                                  if (int.parse(value) >= 18) {
                                    widget.userInfo.age = int.parse(value);
                                    return null;
                                  } else {
                                    return "Age must be above 18";
                                  }
                                },
                                initialValue: widget.userInfo.age.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
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
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
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
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
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
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
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
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Widget> _continentChipDesign() {
    ProfileContinentPreferences pp = ProfileContinentPreferences();
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget1 = Container(
        child: ChoiceChip(
          label: Text(pp.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(pp.colors[i]),
          selected: widget.userInfo.continent.contains(pp.preferences[i]),
          pressElevation: 5.0,
          // disabledColor: Colors.red,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              widget.userInfo.continent.add(pp.preferences[i]);
            } else {
              widget.userInfo.continent.remove(pp.preferences[i]);
            }
            setState(() {});
          },
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4.0),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      );
      widgets.add(widget1);
    }
    return widgets;
  }

  List<Widget> _interestChipDesign() {
    ProfileInterestPreferences pp = ProfileInterestPreferences();
    List<Widget> widgets = List<Widget>();
    //print(editableInfo.matchPrefs);
    // print(editableInfo.interest);
    print("++++++++++++++++++++++");

    //interestChips=userInfo.interest;
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget1 = Container(
        child: ChoiceChip(
          label: Text(pp.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(pp.colors[i]),
          selected: widget.userInfo.interest.contains(pp.preferences[i]),
          pressElevation: 5.0,
          // disabledColor: Colors.red,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              widget.userInfo.interest.add(pp.preferences[i]);
            } else {
              widget.userInfo.interest.remove(pp.preferences[i]);
            }
            setState(() {
              // check = 2;
              // pp.isSelected[i] = !pp.isSelected[i];
            });
          },
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4.0),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      );
      widgets.add(widget1);
    }
    return widgets;
  }

  genderDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                      title: Text("Male"),
                      value: "Male",
                      groupValue: widget.userInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          widget.userInfo.gender = value;
                        });
                      }),
                  RadioListTile(
                      title: Text("Female"),
                      value: "Female",
                      groupValue: widget.userInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          widget.userInfo.gender = value;
                        });
                      }),
                  RadioListTile(
                      title: Text("Others"),
                      value: "Others",
                      groupValue: widget.userInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          widget.userInfo.gender = value;
                        });
                      }),
                  Center(
                    child: FlatButton(
                        onPressed: () {
                          _genderController.text =
                              widget.userInfo.gender.toString();
                          Navigator.of(context).pop();
                        },
                        child: Text("OK")),
                  ),
                ],
              ),
            );
          });
        });
  }
}
