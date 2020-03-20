import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  CurrentUserInfo userInfo;
  ProfileEdit({this.userInfo});
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  static final RegExp nameRegExp = RegExp('[a-zA-Z][a-zA-Z ]*');
  var _gender = ['Male', 'Female', 'Other'];
  //var _forGender = 'Male';
  bool _matchPrefsVisibility = false;
  bool _interestVisibility = false;
  String image;
  //List<String> countries = Country().countries;
  bool male = false;
  bool female = false;
  bool others = false;
  int check = 1;
  File _image;
  bool _isLocalImage = false;
  CurrentUserInfo editableInfo = CurrentUserInfo();
  //CurrentUserInfo userInfo = CurrentUserInfo();
  //List<dynamic> interestChips = List<dynamic>();
  //List<dynamic> continentsChips = List<dynamic>();
  //List<dynamic> matchPrefsChips = List<dynamic>();
  // int selectedColors = 0xFFba68c8;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getAvatar();
  }

  getAvatar() async {
    image = await StorageService().getUserAvatar();
    setState(() {});
  }

  ProfileContinentPreferences _continentPreferences =
      ProfileContinentPreferences();
  ProfileMatchPreferences _matchPreferences = ProfileMatchPreferences();
  @override
  Widget build(BuildContext context) {
    // final userInfo = Provider.of<CurrentUserInfo>(context);
    ScreenSizeConfig().init(context);

    print(widget.userInfo);
    if (widget.userInfo != null && check == 1) {
      editableInfo = widget.userInfo;
      editableInfo.interest = widget.userInfo.interest.toList();
      editableInfo.matchPrefs = widget.userInfo.matchPrefs.toList();
      editableInfo.continent = widget.userInfo.continent.toList();
      check = 2;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(ScreenSizeConfig.blockSizeHorizontal * 10,
            ScreenSizeConfig.blockSizeVertical * 7),
        child: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  // Image(
                  //   image: AssetImage(
                  //     'assets/images/ic_launcher.png',
                  //   ),
                  //   height: ScreenSizeConfig.blockSizeVertical * 7,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: ScreenSizeConfig.safeBlockHorizontal * 100,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Form(
            key: _formKey,
            child: Container(
              // width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (_isLocalImage)
                      ? ((_image != null)
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              backgroundImage: FileImage(_image),
                            )
                          : CircleAvatar())
                      : ((widget.userInfo.avatar != "" &&
                              widget.userInfo.avatar != null)
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              backgroundImage:
                              CachedNetworkImageProvider(widget.userInfo.avatar),
                                  // NetworkImage(widget.userInfo.avatar),
                            )
                          : CircleAvatar()),
                  RaisedButton(
                    child: Text("Pick"),
                    onPressed: () async {
                      _isLocalImage = true;
                      getImage();
                    },
                  ),
                  RaisedButton(
                    child: Text("Upload"),
                    onPressed: () {
                      // StorageService().uploadAvatar(_image);
                    },
                  ),
                  TextFormField(
                    initialValue: editableInfo.name ?? "",
                    decoration: InputDecoration(
                        labelText: "Name",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.tealAccent, width: 2.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter your Name";
                      } else if (nameRegExp.hasMatch(value)) {
                        editableInfo.name = value;
                        return null;
                      } else
                        return "Re-Enter your name";
                    },
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: ScreenSizeConfig.blockSizeHorizontal * 53,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Gender : ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            DropdownButton<String>(
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25.0,
                              elevation: 16,
                              items: _gender.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  editableInfo.gender = newValueSelected;
                                });
                              },
                              value: editableInfo.gender ?? "Other",
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 15.0,
                      // ),
                      Container(
                        alignment: Alignment.topRight,
                        width: ScreenSizeConfig.blockSizeHorizontal * 30,
                        child: TextFormField(
                          initialValue: editableInfo.age.toString() ?? "15",
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.tealAccent, width: 2.0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isNotEmpty && value != null) {
                              if (int.parse(value) < 18)
                                return "Age Must be atleast 18";
                              else {
                                editableInfo.age = int.parse(value);
                                return null;
                              }
                            } else {
                              return "Enter you age";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 3,
                  ),
                  Text(
                    'Match Preference : ',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 1,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Girl'),
                      Checkbox(
                        value: editableInfo.matchPrefs.contains("Girl"),
                        onChanged: (bool value) {
                          if (value) {
                            editableInfo.matchPrefs.add("Girl");
                          } else {
                            editableInfo.matchPrefs.remove("Girl");
                          }
                          setState(() {
                            male = value;
                          });
                        },
                      ),
                      Text('Boy'),
                      Checkbox(
                        value: editableInfo.matchPrefs.contains("Boy"),
                        onChanged: (bool value) {
                          if (value) {
                            editableInfo.matchPrefs.add("Boy");
                          } else {
                            editableInfo.matchPrefs.remove("Boy");
                          }
                          setState(() {
                            female = value;
                          });
                        },
                      ),
                      Text('Couple'),
                      Checkbox(
                        value: editableInfo.matchPrefs.contains("Couple"),
                        onChanged: (bool value) {
                          if (value) {
                            editableInfo.matchPrefs.add("Couple");
                          } else {
                            editableInfo.matchPrefs.remove("Couple");
                          }
                          setState(() {
                            others = value;
                          });
                        },
                      ),
                      Text('Group'),
                      Checkbox(
                        value: editableInfo.matchPrefs.contains("Group"),
                        onChanged: (bool value) {
                          if (value) {
                            editableInfo.matchPrefs.add("Group");
                          } else {
                            editableInfo.matchPrefs.remove("Group");
                          }
                          setState(() {
                            male = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 4,
                    child: Visibility(
                      visible: _matchPrefsVisibility,
                      child: Text(
                        "One of the fields must be selected!",
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 3,
                  ),
                  divider(context),
                  Wrap(
                    children: _interestChipDesign(),
                  ),
                  divider(context),
                  Wrap(
                    children: _continentChipDesign(),
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.blockSizeHorizontal * 4,
                    child: Visibility(
                      visible: _interestVisibility,
                      child: Text(
                        "One of the fields must be selected!",
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 4,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: ScreenSizeConfig.safeBlockHorizontal * 40,
                      child: RaisedButton(
                          splashColor: Colors.red,
                          child: Text(
                            'Submit'.toUpperCase(),
                            style: TextStyle(fontSize: 16.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50)),
                          ),
                          color: Colors.brown,
                          textColor: Colors.black,
                          onPressed: () async {
                            if ((!_formKey.currentState.validate()))
                            //||
                            //  (userInfo.matchPrefs.length == 0) ||
                            //(userInfo.interest.length == 0)))
                            {
                              // setState(() {
                              //   if (userInfo.interest.length == 0) {
                              //     _interestVisibility = true;
                              //   } else {
                              //     _interestVisibility = false;
                              //   }
                              //   if (userInfo.matchPrefs.length == 0) {
                              //     _matchPrefsVisibility = true;
                              //   } else {
                              //     _matchPrefsVisibility = false;
                              //   }
                              // });
                            } else {
                              final pr =
                                  loadingBar(context, "Updating Information");
                              pr.show();
                              insertData(editableInfo, pr);
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSizeConfig.safeBlockVertical * 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // }),
    //);
  }

  List<Widget> _continentChipDesign() {
    ProfileContinentPreferences pp = ProfileContinentPreferences();
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget = Container(
        child: ChoiceChip(
          label: Text(pp.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(pp.colors[i]),
          selected: editableInfo.continent.contains(pp.preferences[i]),
          pressElevation: 5.0,
          // disabledColor: Colors.red,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              editableInfo.continent.add(pp.preferences[i]);
            } else {
              editableInfo.continent.remove(pp.preferences[i]);
            }
            setState(() {});
          },
          shadowColor: Colors.grey[50],
          padding: EdgeInsets.all(4.0),
        ),
        margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
      );
      widgets.add(widget);
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
      Widget widget = Container(
        child: ChoiceChip(
          label: Text(pp.preferences[i],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Color(pp.colors[i]),
          selected: editableInfo.interest.contains(pp.preferences[i]),
          pressElevation: 5.0,
          // disabledColor: Colors.red,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            if (selected) {
              editableInfo.interest.add(pp.preferences[i]);
            } else {
              editableInfo.interest.remove(pp.preferences[i]);
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
      widgets.add(widget);
    }
    return widgets;
  }

  Container divider(BuildContext context) => Container(
        child: Divider(),
      );

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uploadContext(BuildContext context) async {
    String fileName = _image.path.split('/').removeLast();
    print(fileName);

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("dsaasd").child("hh.jpeg");
    print(_image);
    StorageUploadTask task = storageReference.putFile(_image);
    await task.onComplete;
    print("UPLOADED");
  }

  insertData(CurrentUserInfo userInfo, ProgressDialog pr) async {
    print("object");
    userInfo = editableInfo;
    print(userInfo.age);
    print(userInfo.matchPrefs);
    print(userInfo.gender);
    print(userInfo.name);
    print(userInfo.continent);

    // DatabaseService().updateUserProfile(editableInfo);
    await DatabaseService().updateUserProfile(editableInfo);
    if (_isLocalImage) {
      await StorageService().uploadUserAvatar(_image);
    }
    await pr.hide().whenComplete(() {
      SnackBar(content: Text("Edit Successful"));
    });
    Navigator.pop(context);
    // DatabaseService().updateUserProfile().then((onValue) {
    //   print(onValue);
    //   Future.delayed(Duration(seconds: 12));
    //   pr.hide().whenComplete(() {
    //     print("DONE");
    //     // Navigator.of(context).pushAndRemoveUntil(
    //     //     MaterialPageRoute(builder: (context) => HomePage()),
    //     //     (Route<dynamic> route) => false);
    //   });
    // });
  }
}
