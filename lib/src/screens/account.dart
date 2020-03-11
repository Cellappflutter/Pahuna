import 'dart:io';

import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
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
  bool prefgender = false;
  int prefcount = 0;
  TextEditingController _genderController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool prefcontinent = false;
  bool prefinterest = false;
  File _image;
  bool _isLocalImage = false;
  bool edit = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CurrentUserInfo editableInfo;
  int check = 1;
  // RangeValues values=DiscoverySetting.agePrefs;
  @override
  Widget build(BuildContext context) {
    if (check == 1) {
      editableInfo = widget.userInfo ?? CurrentUserInfo();
      if (editableInfo.continent == null) {
        editableInfo.continent = [];
      }

      if (editableInfo.matchPrefs == null) {
        editableInfo.matchPrefs = [];
      }

      if (editableInfo.interest == null) {
        editableInfo.interest = [];
      }
      _nameController.text = editableInfo.name.toString() ?? '';
      _ageController.text = editableInfo.age.toString() ?? '';
      _emailController.text = editableInfo.email.toString() ?? '';
      _descriptionController.text = editableInfo.description.toString() ?? '';
      check = 2;
    }
    print("-------------");
    print(editableInfo.name);
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, "Profile"),
          body: SingleChildScrollView(
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
                              (editableInfo.name != null &&
                                      editableInfo.name != '')
                                  ? (editableInfo.name)
                                  : ("Your Name"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.display2,
                            ),
                            Text(
                              (editableInfo.email != null &&
                                      editableInfo.email != '')
                                  ? (editableInfo.email)
                                  : ("your@email"),
                              // editableInfo.email,
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
                                if (edit) {
                                  await avatarPicker();
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return Dialog(
                                          child: (_isLocalImage)
                                              ? ((_image != null)
                                                  ? Image.file(
                                                      _image,
                                                    )
                                                  : Container(
                                                      color: Colors.red,
                                                      height: 100,
                                                    ))
                                              : ((editableInfo.avatar != "" &&
                                                      editableInfo.avatar !=
                                                          null)
                                                  ? Container(
                                                      child: Image.network(
                                                          editableInfo.avatar),
                                                    )
                                                  : Container(
                                                      color: Colors.red,
                                                      height: 100,
                                                    )),
                                        );
                                      });
                                }
                              },
                              child: (_isLocalImage)
                                  ? ((_image != null)
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(_image),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.red,
                                        ))
                                  : ((editableInfo.avatar != "" &&
                                          editableInfo.avatar != null)
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(editableInfo.avatar),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                          onTap: () async {
                            if (edit) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Are you Sure"),
                                      content: Text("Do you want to Save?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () async {
                                              ProgressDialog pr = loadingBar(
                                                  context,
                                                  "Updating Information");
                                              if (_formKey.currentState.validate() &&
                                                  _descriptionController.text !=
                                                      null &&
                                                  _descriptionController.text
                                                          .trim() !=
                                                      '' &&
                                                  editableInfo
                                                          .matchPrefs.length >
                                                      0 &&
                                                  editableInfo
                                                          .continent.length >
                                                      0 &&
                                                  editableInfo.interest.length >
                                                      0) {
                                                pr.show();
                                                editableInfo.description =
                                                    _descriptionController.text;
                                                await DatabaseService()
                                                    .updateUserProfile(
                                                        editableInfo);

                                                PaintingBinding
                                                    .instance.imageCache
                                                    .clear();
                                                await uploadAvatar(context);
                                                await Prefs.setRangeData(
                                                    DiscoverySetting.range);
                                                await Prefs.setEndAgeData(
                                                    DiscoverySetting
                                                        .agePrefs.end);
                                                await Prefs.setStartAgeData(
                                                    DiscoverySetting
                                                        .agePrefs.start);
                                                pr.dismiss();

                                                Navigator.of(context).pop();
                                                setState(() {
                                                  edit = !edit;
                                                });
                                              } else {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: Text(
                                                          'Invalid form, please enter all field ',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Text("Yes")),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                edit = !edit;
                                                check = 1;
                                                _image = null;
                                                _isLocalImage = false;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("NO"))
                                      ],
                                    );
                                  });
                            } else {
                              setState(() {
                                edit = !edit;
                              });
                            }
                          },
                          child: edit == false
                              ? Container(
                                  child: Column(children: <Widget>[
                                  Icon(UiIcons.edit),
                                  Text('Edit',
                                      style: Theme.of(context).textTheme.body1)
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
                                    setState(() {
                                      edit = false;
                                    });
                                  } else {
                                    print("This is from Following $edit");
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
                                      style: Theme.of(context).textTheme.body1)
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
                          color: Theme.of(context).hintColor.withOpacity(0.15),
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
                          title: Row(
                            children: <Widget>[
                              Icon(UiIcons.user_1),
                              SizedBox(width: 10),
                              Text("Profile Settings",
                                  // style: Theme.of(context).textTheme.body2
                                  )
                            ],
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
                                if (value != null &&
                                    value.trim() != "" &&
                                    value != "null") {
                                  editableInfo.name = value;
                                  return null;
                                } else {
                                  return "Name cannot be empty";
                                }
                              },
                              controller: _nameController,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          ),
                        ),
                        ListTile(
                          enabled: edit,
                          onTap: () async {
                            if (edit) {
                              await genderDialog();
                              setState(() {});
                            }
                          },
                          dense: true,
                          title: Text(
                            'Gender',
                            style: Theme.of(context).textTheme.body1,
                          ),
                          trailing: Container(
                            width: ScreenSizeConfig.safeBlockHorizontal * 50,
                            child: Text(
                              editableInfo.gender.toString(),
                              // controller: _genderController,
                              // decoration: InputDecoration(
                              //   border: InputBorder.none,
                              //   hintText: 'Gender',
                              // ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
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
                              // controller: _ageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Age',
                              ),
                              keyboardType: TextInputType.number,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              enabled: edit,
                              validator: (value) {
                                if (int.parse(value) >= 18 &&
                                    int.parse(value) != null &&
                                    value != "null") {
                                  editableInfo.age = int.parse(value);
                                  return null;
                                }
                              },
                              // initialValue: editableInfo.age.toString(),
                              controller: _ageController,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: (Text(
                            'Email',
                            style: Theme.of(context).textTheme.body1,
                          )),
                          trailing: Container(
                            width: ScreenSizeConfig.safeBlockHorizontal * 50,
                            child: TextFormField(
                              //  controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              enabled: edit,
                              validator: (value) {
                                if (value != null &&
                                    value.trim() != "" &&
                                    value != "null") {
                                  editableInfo.email = value;
                                  return null;
                                } else {
                                  return "Email cannot be empty";
                                }
                              },
                              //  initialValue: editableInfo.email.toString(),
                              controller: _emailController,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          ),
                        ),
                        // ListTile(
                        //   onTap: () {},
                        //   dense: true,
                        //   title: Text(
                        //     'Match Preferences',
                        //     style: Theme.of(context).textTheme.body1,
                        //   ),
                        //   trailing: Text(
                        //     editableInfo.matchPrefs.toString(),
                        //     // _user.getDateOfBirth()                          ,
                        //     style:
                        //         TextStyle(color: Theme.of(context).focusColor),
                        //   ),
                        // ),
                        // ListTile(
                        //   onTap: () {},
                        //   dense: true,
                        //   title: Text(
                        //     'Continent',
                        //     style: Theme.of(context).textTheme.body1,
                        //   ),
                        //   trailing: Text(
                        //     editableInfo.continent.toString(),
                        //     style:
                        //         TextStyle(color: Theme.of(context).focusColor),
                        //   ),
                        // )
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
                        // leading: Icon(UiIcons.file_2),
                        // title: Text('Description',
                        //     style: Theme.of(context).textTheme.body2)),
                        title: Row(
                          children: <Widget>[
                            Icon(UiIcons.file_2),
                            SizedBox(width: 10),
                            Text("Description",
                                // style: Theme.of(context).textTheme.body2
                                ),
                          ],
                        ),
                      ),
                      ListTile(
                        subtitle: TextFormField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "About yourself..."),
                          enabled: edit,
                          validator: (value) {
                            if (value != null && value.trim() != '' && value != "null")
                              editableInfo.description = value;
                            return null;
                          },
                          //  initialValue: editableInfo.description,
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
                          blurRadius: 10),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      ListTile(
                        // leading: Icon(UiIcons.loupe),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(UiIcons.loupe),
                            SizedBox(width: 10),
                            Text(
                              "Search Preferences",
                              // style: Theme.of(context).textTheme.body2,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          if (edit) {
                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Dialog(
                                      child: Column(
                                    children: <Widget>[
                                      Wrap(children: _matchPrefsChipDesign()),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok"))
                                    ],
                                  ));
                                });
                            setState(() {});
                          }
                        },
                        dense: true,
                        title: Text("Match Preferences",
                            style: Theme.of(context).textTheme.body1),
                        trailing: Text(editableInfo.matchPrefs.toString(),
                            style:
                                TextStyle(color: Theme.of(context).focusColor)),
                      ),
                      ListTile(
                        onTap: () async {
                          if (edit) {
                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Dialog(
                                      child: Column(
                                    children: <Widget>[
                                      Wrap(children: _continentChipDesign()),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok"))
                                    ],
                                  ));
                                });
                            setState(() {});
                          }
                        },
                        dense: true,
                        title: Text("Continent",
                            style: Theme.of(context).textTheme.body1),
                        trailing: Text(editableInfo.continent.toString(),
                            style:
                                TextStyle(color: Theme.of(context).focusColor)),
                      ),
                      ListTile(
                          onTap: () async {
                            if (edit) {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Dialog(
                                        child: Column(
                                      children: <Widget>[
                                        Wrap(children: _interestChipDesign()),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ));
                                  });
                              setState(() {});
                            }
                          },
                          dense: false,
                          title: Text("Interest",
                              style: Theme.of(context).textTheme.body1),
                          trailing: Text(
                            editableInfo.interest.toString(),
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                          ))
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
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
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
                          children: <Widget>[
                            Icon(
                              UiIcons.settings_2,
                            ),
                            SizedBox(width: 10),
                            Text("Discovery Settings",
                                // style: Theme.of(context).textTheme.body2
                                ),
                          ],
                        )),
                        ListTile(
                          dense: true,
                          title: Text("Range"),
                          trailing: Text(DiscoverySetting.range.toString()),
                          subtitle: Slider(
                            value: DiscoverySetting.range,
                            onChanged: (value) {
                              setState(() {
                                if (edit) {
                                  DiscoverySetting.range = value;
                                }
                              });
                            },
                            activeColor: Colors.red,
                            inactiveColor: Colors.red,
                            min: 0,
                            max: 20,
                            divisions: 10,
                            // label: DiscoverySetting.range.toString(),
                          ),
                        ),
                        ListTile(
                          enabled: edit,
                          dense: true,
                          title: Text("Age Preferences"),
                          trailing: Text(DiscoverySetting.agePrefs.start
                                  .round()
                                  .toString() +
                              "-" +
                              DiscoverySetting.agePrefs.end.round().toString()),
                          subtitle: RangeSlider(
                            onChanged: (value) {
                              if (edit) {
                                setState(() {
                                  DiscoverySetting.agePrefs = value;
                                });
                              }
                            },
                            values: DiscoverySetting.agePrefs,
                            activeColor: Colors.red,
                            min: 18,
                            max: 80,
                            inactiveColor: Colors.red,
                            divisions: 10,
                          ),
                        )
                      ],
                    )),
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
                        // leading: Icon(UiIcons.settings_1),
                        // title: Text(
                        //   'Account Settings',
                        //   style: Theme.of(context).textTheme.body2,
                        // ),
                        title: Row(
                          children: <Widget>[
                            Icon(UiIcons.settings),
                            SizedBox(width: 10),
                            Text("Accoutn Settings",
                                // style: Theme.of(context).textTheme.body2
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
          //  ),
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

  List<Widget> _matchPrefsChipDesign() {
    ProfileMatchPreferences pp = ProfileMatchPreferences();
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget1 = StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            child: ChoiceChip(
              label: Text(pp.preferences[i],
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Color(pp.colors[i]),
              selected: (editableInfo.matchPrefs != null)
                  ? editableInfo.matchPrefs.contains(pp.preferences[i])
                  : false,
              pressElevation: 5.0,
              // disabledColor: Colors.red,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                if (selected) {
                  prefcount++;
                  prefgender = true;
                  editableInfo.matchPrefs.add(pp.preferences[i]);
                } else {
                  prefcount--;
                  editableInfo.matchPrefs.remove(pp.preferences[i]);
                }

                setState(() {});
              },
              shadowColor: Colors.grey[50],
              padding: EdgeInsets.all(4.0),
            ),
            margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          );
        },
      );
      widgets.add(widget1);
    }
    //if(count>0){return widgets;}
    return widgets;
  }

  List<Widget> _continentChipDesign() {
    int count = 0;
    ProfileContinentPreferences pp = ProfileContinentPreferences();
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget1 = StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            child: ChoiceChip(
              label: Text(pp.preferences[i],
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Color(pp.colors[i]),
              selected: (editableInfo.continent != null)
                  ? editableInfo.continent.contains(pp.preferences[i])
                  : false,
              pressElevation: 5.0,
              // disabledColor: Colors.red,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                if (selected) {
                  count++;
                  editableInfo.continent.add(pp.preferences[i]);
                } else {
                  count--;
                  editableInfo.continent.remove(pp.preferences[i]);
                }
                if (count > 0) {
                  prefcontinent = true;
                } else {
                  prefcontinent = false;
                }
                setState(() {});
              },
              shadowColor: Colors.grey[50],
              padding: EdgeInsets.all(4.0),
            ),
            margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          );
        },
      );
      widgets.add(widget1);
    }
    return widgets;
  }

  List<Widget> _interestChipDesign() {
    int count = 0;
    ProfileInterestPreferences pp = ProfileInterestPreferences();
    List<Widget> widgets = List<Widget>();
    //print(editableInfo.matchPrefs);
    // print(editableInfo.interest);
    print("++++++++++++++++++++++");

//interestChips=userInfo.interest;
    for (int i = 0; i < pp.preferences.length; i++) {
      Widget widget1 = StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            child: ChoiceChip(
              label: Text(pp.preferences[i],
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Color(pp.colors[i]),
              selected: (editableInfo.interest != null)
                  ? editableInfo.interest.contains(pp.preferences[i])
                  : false,
              pressElevation: 5.0,
              // disabledColor: Colors.red,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                if (selected) {
                  count++;
                  editableInfo.interest.add(pp.preferences[i]);
                } else {
                  count--;
                  editableInfo.interest.remove(pp.preferences[i]);
                }
                if (count > 0) {
                  prefinterest = true;
                } else {
                  prefinterest = false;
                }
                setState(() {});
              },
              shadowColor: Colors.grey[50],
              padding: EdgeInsets.all(4.0),
            ),
            margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          );
        },
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
                      groupValue: editableInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          editableInfo.gender = value;
                        });
                      }),
                  RadioListTile(
                      title: Text("Female"),
                      value: "Female",
                      groupValue: editableInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          editableInfo.gender = value;
                        });
                      }),
                  RadioListTile(
                      title: Text("Others"),
                      value: "Others",
                      groupValue: editableInfo.gender,
                      onChanged: (value) {
                        setState(() {
                          editableInfo.gender = value;
                        });
                      }),
                  Center(
                    child: FlatButton(
                        onPressed: () {
                          _genderController.text =
                              editableInfo.gender.toString();
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
