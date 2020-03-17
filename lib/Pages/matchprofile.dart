import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchProfile extends StatefulWidget {
  final String userid;
  MatchProfile({this.userid});
  @override
  _MatchProfileState createState() => _MatchProfileState();
}

class _MatchProfileState extends State<MatchProfile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _genderController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    bool edit = false;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    CurrentUserInfo editableInfo;
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Profile"),
        body: MultiProvider(
          providers: [
            FutureProvider<String>.value(
                value: StorageService().getAvatar(widget.userid)),
            StreamProvider<CurrentUserInfo>.value(
              value: DatabaseService().getOtherUserData(widget.userid),
            )
          ],
          child: Consumer<CurrentUserInfo>(
            builder: (context, userInfo, child) {
              if (userInfo != null) {
                editableInfo = userInfo;
                final avatar = Provider.of<String>(context);
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
                _descriptionController.text =
                    editableInfo.description.toString() ?? '';
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 7),
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
                                    (editableInfo.name != null)
                                        ? (editableInfo.name.toString())
                                        : ("Your Name"),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                  Text(
                                    editableInfo.email.toString(),
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
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return Dialog(
                                              child: ((avatar != "" &&
                                                      avatar != null)
                                                  ? Container(
                                                      child: CachedNetworkImage(
                                                        imageUrl: avatar,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                      // Image.network(
                                                      //     avatar),
                                                    )
                                                  : Container(
                                                      color: Colors.red,
                                                      height: 100,
                                                    )),
                                            );
                                          });
                                    },
                                    child: ((avatar != "" && avatar != null)
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(avatar),
                                          )
                                        : CircleAvatar()))),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
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
                                // leading: Icon(UiIcons.user_1),
                                // title: Text(
                                //   'Profile Settings',
                                //   style: Theme.of(context).textTheme.body2,
                                // ),
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      UiIcons.user_1,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text("Profile Settings",
                                        style:
                                            Theme.of(context).textTheme.body2)
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
                                  width:
                                      ScreenSizeConfig.safeBlockHorizontal * 50,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Full Name',
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    enabled: edit,
                                    validator: (value) {
                                      editableInfo.name = value;
                                      return null;
                                    },
                                    controller: _nameController,
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                ),
                              ),
                              ListTile(
                                enabled: edit,
                                dense: true,
                                title: Text(
                                  'Gender',
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                trailing: Container(
                                  width:
                                      ScreenSizeConfig.safeBlockHorizontal * 50,
                                  child: Text(
                                    editableInfo.gender.toString(),
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
                                  width:
                                      ScreenSizeConfig.safeBlockHorizontal * 50,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Age',
                                    ),
                                    keyboardType: TextInputType.number,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    enabled: edit,
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
                                  width:
                                      ScreenSizeConfig.safeBlockHorizontal * 50,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
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
                                  Icon(
                                    UiIcons.file_2,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Description",
                                      style: Theme.of(context).textTheme.body2)
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
                                  editableInfo.description = value;
                                  return null;
                                },
                                //  initialValue: editableInfo.description,
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
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
                                  Icon(
                                    UiIcons.loupe,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Search Preferences",
                                    // style: Theme.of(context).textTheme.body2,
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Match Preferences",
                                  style: Theme.of(context).textTheme.body1),
                              trailing: Text(editableInfo.matchPrefs.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor)),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Continent",
                                  style: Theme.of(context).textTheme.body1),
                              trailing: Text(editableInfo.continent.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor)),
                            ),
                            ListTile(
                                dense: false,
                                title: Text("Interest",
                                    style: Theme.of(context).textTheme.body1),
                                trailing: Text(
                                  editableInfo.interest.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    color: Colors.red,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            // child: SingleChildScrollView(
          ),
        ),
      ),
    );
  }
}
