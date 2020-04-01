import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/Pages/photos.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:ecommerce_app_ui_kit/src/screens/messages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AccountWidget extends StatefulWidget {
  final bool tutorialShow;
  final CurrentUserInfo userInfo;
  AccountWidget({this.tutorialShow, this.userInfo});
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

typedef void VoidCallback(int data);

class _AccountWidgetState extends State<AccountWidget> {
  TextEditingController _genderController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _ageFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  File _image;
  bool _isLocalImage = false;
  bool edit = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CurrentUserInfo editableInfo;
  int check = 1;
  GlobalKey _editButtonKey = GlobalKey();
  GlobalKey _avatarKey = GlobalKey();
  String tempGender;
  @override
  void initState() {
    if (widget.tutorialShow ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showProfileIntro());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    if (check == 1) {
      editableInfo = widget.userInfo ?? CurrentUserInfo();
      tempGender = widget.userInfo.gender;
      if (editableInfo.continent == null) {
        editableInfo.continent = [];
      }

      if (editableInfo.matchPrefs == null) {
        editableInfo.matchPrefs = [];
      }

      if (editableInfo.interest == null) {
        editableInfo.interest = [];
      }
      _nameController.text = editableInfo.name ?? '';
      _ageController.text = editableInfo.age.toString() ?? '';
      _emailController.text = editableInfo.email ?? '';
      _descriptionController.text = editableInfo.description ?? '';
      check = 2;
    }
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, "Edit Profile"),
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
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(
                          key: _avatarKey,
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
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            editableInfo.avatar,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
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
                                              CachedNetworkImageProvider(
                                                  editableInfo.avatar),
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
                              ProgressDialog pr =
                                  loadingBar(context, "Updating Information");
                              if (_formKey.currentState.validate() &&
                                  _descriptionController.text != null &&
                                  _descriptionController.text.trim() != '' &&
                                  editableInfo.continent.length > 0 &&
                                  editableInfo.matchPrefs.length > 0 &&
                                  editableInfo.interest.length > 0) {
                                pr.show();
                                editableInfo.description =
                                    _descriptionController.text;
                                editableInfo.gender = tempGender;
                                PaintingBinding.instance.imageCache.clear();
                                await Future.wait([
                                  DatabaseService()
                                      .updateUserProfile(editableInfo),
                                  uploadAvatar(context),
                                  Prefs.setRangeData(DiscoverySetting.range),
                                  Prefs.setEndAgeData(
                                      DiscoverySetting.agePrefs.end),
                                  Prefs.setStartAgeData(
                                      DiscoverySetting.agePrefs.start),
                                ]);
                                pr.dismiss();
                                setState(() {
                                  edit = !edit;
                                });
                                if (widget.tutorialShow ?? false) {
                                  _readyForMatch();
                                }
                              } else {
                                showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Invalid form, please enter all field ',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      );
                                    });
                              }
                              
                            } else {
                              setState(() {
                                edit = !edit;
                              });
                            }
                          },
                          child: edit == false
                              ? Container(
                                  child: Column(
                                    key: _editButtonKey,
                                    children: <Widget>[
                                      Icon(UiIcons.edit),
                                      Text('Edit',
                                          style:
                                              Theme.of(context).textTheme.body1)
                                    ],
                                  ),
                                )
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPhotos(userId: DatabaseService.uid,)));
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => UserPhotos(
                              //       userId: DatabaseService.uid,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(UiIcons.photo_camera),
                                  Text("Gallery",
                                      style: Theme.of(context).textTheme.body1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (edit == true) {
                                return null;
                              } else {
                                print("This is from message $edit");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Messagelist()));
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
                              Text(
                                "Profile Settings",
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            _nameFocusNode.requestFocus();
                          },
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
                              focusNode: _nameFocusNode,
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
                              tempGender.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            _ageFocusNode.requestFocus();
                          },
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
                              textAlign: TextAlign.right,
                              enabled: edit,
                              focusNode: _ageFocusNode,
                              validator: (value) {
                                if (int.parse(value) >= 18 &&
                                    int.parse(value) != null &&
                                    value != "null") {
                                  editableInfo.age = int.parse(value);
                                  return null;
                                } else {
                                  return "Age Must be greator than 18";
                                }
                              },
                              controller: _ageController,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            _emailFocusNode.requestFocus();
                          },
                          dense: true,
                          title: (Text(
                            'Email',
                            style: Theme.of(context).textTheme.body1,
                          )),
                          trailing: Container(
                            width: ScreenSizeConfig.safeBlockHorizontal * 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.right,
                              enabled: edit,
                              focusNode: _emailFocusNode,
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
                              controller: _emailController,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
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
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(UiIcons.file_2),
                            SizedBox(width: 10),
                            Text(
                              "Description",
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
                            if (value != null &&
                                value.trim() != '' &&
                                value != "null")
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
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(UiIcons.loupe),
                            SizedBox(width: 10),
                            Text(
                              "Search Preferences",
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
                                    mainAxisSize: MainAxisSize.min,
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
                        subtitle: Wrap(
                          spacing: 5,
                          children: getChips(editableInfo.matchPrefs,
                              ProfileMatchPreferences().colors),
                        ),
                        // trailing: (editableInfo.matchPrefs.length > 0)
                        //     ? Text("[...........]",
                        //         style: TextStyle(
                        //             color: Theme.of(context).focusColor))
                        //     : Text("Match Preferences",
                        //         style: TextStyle(color: Colors.black38)),
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
                                    mainAxisSize: MainAxisSize.min,
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
                        subtitle: Wrap(
                          spacing: 5,
                          children: getChips(editableInfo.continent,
                              ProfileContinentPreferences().colors),
                        ),
                        // trailing: (editableInfo.continent.length > 0)
                        //     ? Text("[...........]",
                        //         style: TextStyle(
                        //             color: Theme.of(context).focusColor))
                        //     : Text("Continent",
                        //         style: TextStyle(color: Colors.black38)),
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
                                    mainAxisSize: MainAxisSize.min,
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
                        subtitle: Wrap(
                          spacing: 5,
                          children: getChips(editableInfo.interest,
                              ProfileInterestPreferences().colors),
                        ),
                        // trailing: (editableInfo.interest.length > 0)
                        //     ? Text("[...........]",
                        //         style: TextStyle(
                        //             color: Theme.of(context).focusColor))
                        //     : Text("Interest",
                        //         style: TextStyle(color: Colors.black38)),
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
                            Text(
                              "Discovery Settings",
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
                        title: Row(
                          children: <Widget>[
                            Icon(UiIcons.settings),
                            SizedBox(width: 10),
                            Text(
                              "Account Settings",
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {},
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
                        onTap: () {},
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

  Future<bool> uploadAvatar(BuildContext context) async {
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
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                if (selected) {
                  editableInfo.matchPrefs.add(pp.preferences[i]);
                } else {
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
    return widgets;
  }

  List<Widget> _continentChipDesign() {
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
        },
      );
      widgets.add(widget1);
    }
    return widgets;
  }

  List<Widget> _interestChipDesign() {
    ProfileInterestPreferences pp = ProfileInterestPreferences();
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
              selected: (editableInfo.interest != null)
                  ? editableInfo.interest.contains(pp.preferences[i])
                  : false,
              pressElevation: 5.0,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                if (selected) {
                  editableInfo.interest.add(pp.preferences[i]);
                } else {
                  editableInfo.interest.remove(pp.preferences[i]);
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
                    groupValue: tempGender,
                    onChanged: (value) {
                      setState(() {
                        tempGender = value;
                      });
                    }),
                RadioListTile(
                    title: Text("Female"),
                    value: "Female",
                    groupValue: tempGender,
                    onChanged: (value) {
                      setState(() {
                        tempGender = value;
                      });
                    }),
                RadioListTile(
                    title: Text("Others"),
                    value: "Others",
                    groupValue: tempGender,
                    onChanged: (value) {
                      setState(() {
                        tempGender = value;
                      });
                    }),
                Center(
                  child: FlatButton(
                      onPressed: () {
                        _genderController.text = tempGender.toString();
                        Navigator.of(context).pop();
                      },
                      child: Text("OK")),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showProfileIntro() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: TyperAnimatedTextKit(
              text: [
                "Looks like, your profile isnt ready yet, Why dont u give use some information to begin with"
              ],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              displayFullTextOnTap: true,
              onFinished: () {
                Future.delayed(Duration(seconds: 1)).then((onValue) {
                  Navigator.of(context).pop();
                });
              },
              speed: Duration(milliseconds: 50),
              pause: Duration(milliseconds: 200),
              isRepeatingAnimation: false,
              textStyle: TextStyle(fontSize: 25, color: Colors.white),
            ),
          );
        }).then((onValue) {
      _editCoachMark();
    });
  }

  void _readyForMatch() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: TyperAnimatedTextKit(
              text: ["Awesome!, Let's find a match right away!"],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              displayFullTextOnTap: true,
              onFinished: () {
                Future.delayed(Duration(seconds: 1)).then((onValue) {
                  Navigator.of(context).pop();
                });
              },
              speed: Duration(milliseconds: 50),
              pause: Duration(milliseconds: 200),
              isRepeatingAnimation: false,
              textStyle: TextStyle(fontSize: 25, color: Colors.white),
            ),
          );
        }).then((onValue) {
      Navigator.pop(context, true);
    });
  }

  void _editCoachMark() {
    CoachMark coachMark = CoachMark();
    RenderBox targetRenderBox =
        _editButtonKey.currentContext.findRenderObject();
    Rect rect =
        targetRenderBox.localToGlobal(Offset.zero) & targetRenderBox.size;
    rect = Rect.fromCircle(center: rect.center, radius: rect.longestSide * 0.3);
    coachMark.show(
        targetContext: _editButtonKey.currentContext,
        onClose: () {
          _avatarCoachMark();
        },
        children: [
          Positioned(
              left: rect.left,
              right: rect.right,
              top: rect.top - 55,
              bottom: rect.bottom,
              child: Text(
                "Press Here to Edit your Profile",
                style: TextStyle(color: Colors.red, fontSize: 25),
              ))
        ],
        markRect: rect);
  }

  void _avatarCoachMark() {
    CoachMark coachMark = CoachMark();
    RenderBox targetRenderBox = _avatarKey.currentContext.findRenderObject();
    Rect rect =
        targetRenderBox.localToGlobal(Offset.zero) & targetRenderBox.size;
    rect = Rect.fromCircle(center: rect.center, radius: rect.longestSide * 0.5);
    coachMark.show(
        targetContext: _avatarKey.currentContext,
        onClose: () {},
        children: [
          Positioned(
              left: rect.left / 2,
              right: 0,
              top: rect.top - 55,
              bottom: rect.bottom,
              child: Text(
                "Press Here to insert your avatar",
                style: TextStyle(color: Colors.red, fontSize: 25),
              ))
        ],
        markRect: rect);
  }
}
