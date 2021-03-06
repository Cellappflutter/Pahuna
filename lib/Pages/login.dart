import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/database/auth.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/Helper/error_helper.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool _showPassword = false;
  final String tos = 'https://google.com.np';
  String phoneNo, smsCode, verificationID, conv;
  int holder = 977;
  bool i = false;
  ProgressDialog pr;

  Future<void> verifyPhone() async {
    print("VerifyPhone");
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationID = verId;
    };

    final PhoneCodeSent smsCode = (String verId, [int foreceCodeResend]) {
      print("SMS COde ma");
      this.verificationID = verId;
      smsCodeDialogue(context).then((value) {
        print('Signed in - from smscode');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      print("Success");
      // pr.dismiss();
      //    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageWrapper()));
      print("phone verified completed");
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      pr.dismiss();
      print("verify failed");
      switch (exception.code) {
        default:
          {
            errorDialog(context, exception.message);
            break;
          }
      }
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed,
        codeSent: smsCode,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  verifyFailed(PlatformException exception) {
    print("Numver verify failed");
    pr.dismiss();
    switch (exception.code) {
      case verifyError:
        {
          errorDialog(context, "Verification Phone Number Error");
          break;
        }
      case invalidCredential:
        {
          errorDialog(
              context, "Invalid Credentials, Please Enter your number again");
          break;
        }
      case invalidCode:
        {
          errorDialog(context, "Invalid Verification Code, Please retry");
          break;
        }
      default:
        {
          errorDialog(context, exception.message);
          break;
        }
    }
  }

  Future<bool> smsCodeDialogue(BuildContext context) {
    print("sms code dialogue");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter SMS Code"),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14))),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (this.smsCode == null || this.smsCode.length == 0) {
                    print("----------------sms null");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Alert !!"),
                          content: Text("Please Enter Verification Code"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                    signIn();
                  }
                },
                child: Text("Done"),
              ),
              Container(
                width: 90,
                child: Center(
                  child: StreamBuilder(
                    stream: _stream(),
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              pr = loadingBar(context, "Signing In");
                              verifyPhone();
                            },
                            child: Text("Resend"));
                      } else {
                        return Text("${snapshot.data.toString()}",
                            style: TextStyle(fontSize: 18));
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }

  Stream<int> _stream() {
    Duration interval = Duration(seconds: 1);
    Stream<int> stream = Stream<int>.periodic(interval, transform);
    stream = stream.take(62);
    return stream;
  }

  int transform(int value) {
    return value;
  }

  signIn() async {
    pr.show();
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationID, smsCode: smsCode);
      AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await Prefs.setUserUid(authResult.user.uid);

      double range = await Prefs.getRangeData();
      double start = await Prefs.getStartAgeData();
      double end = await Prefs.getEndAgeData();
      DiscoverySetting.agePrefs = RangeValues(start, end);
      DiscoverySetting.range = range;
      DatabaseService.uid = authResult.user.uid;
      await DatabaseService().initUserDB();
      pr.dismiss();
      DatabaseService.uid = authResult.user.uid;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPageWrapper()),
          (Route<dynamic> route) => false);
    } catch (e) {
      verifyFailed(e);
    }
  }

  FacebookLogin fblogin = FacebookLogin();

  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                // alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenSizeConfig.safeBlockVertical * 5,
                        horizontal: ScreenSizeConfig.safeBlockHorizontal * 8),
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenSizeConfig.safeBlockVertical * 20,
                        horizontal: ScreenSizeConfig.safeBlockHorizontal * 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    margin: EdgeInsets.fromLTRB(
                      ScreenSizeConfig.blockSizeVertical * 5,
                      ScreenSizeConfig.blockSizeVertical * 23,
                      ScreenSizeConfig.blockSizeVertical * 5,
                      ScreenSizeConfig.blockSizeVertical * 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Sign Up',
                            style: Theme.of(context).textTheme.display3),
                        SizedBox(
                            height: ScreenSizeConfig.safeBlockVertical * 5),
                        CountryPickerDropdown(
                          initialValue: 'np',
                          itemBuilder: _builderDropdownItem,
                          onValuePicked: (Country country) {
                            setState(() {
                              holder = int.parse(country.phoneCode);
                            });
                          },
                        ),
                        new TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          decoration: new InputDecoration(
                            hintText: 'Phone No.',
                            hintStyle: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              UiIcons.smartphone,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onChanged: (value) {
                            this.phoneNo = "+" + holder.toString() + value;
                            print(phoneNo);
                          },
                        ),
                        SizedBox(
                            height: ScreenSizeConfig.safeBlockVertical * 2),
                        getTOSWidget(),
                        SizedBox(
                            height: ScreenSizeConfig.safeBlockVertical * 2),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 70),
                          onPressed: () {
                            if (i) {
                              if (this.phoneNo.isEmpty) {
                                try {
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text('Alert !!'),
                                        content: Text(
                                            'Please Enter Your Mobile Number'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'),
                                          )
                                        ],
                                      ));
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                pr = loadingBar(context, "Signing In");
                                verifyPhone();
                              }
                            } else {
                              checkBoxDialog();
                            }
                          },
                          child: Text(
                            'Get Code',
                            style: Theme.of(context).textTheme.title.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(
                            height: ScreenSizeConfig.safeBlockVertical * 1),
                        Text(
                          "OR",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: ScreenSizeConfig.safeBlockVertical * 1,
                        ),
                        socialMediaAuthentication(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTOSWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
              activeColor: Colors.white,
              checkColor: Theme.of(context).accentColor,
              value: i,
              onChanged: (bool value) {
                setState(() {
                  i = value;
                  print(value);
                });
              }),
          Container(
            width: ScreenSizeConfig.safeBlockHorizontal * 51.5,
            child: RichText(
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "By using this application, you agree to Pahuna's ",
                style: TextStyle(
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Terms of Service and Privacy Notice.',
                    style: TextStyle(
                      color: Theme.of(context).indicatorColor,
                      // color: Color.fromRGBO(41, 128, 185, 1),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launch(tos),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  socialMediaAuthentication() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () async {
            if (i) {
              await AuthService().signInGoogle().then((user) {
                if (user != null) {
                  if (user.additionalUserInfo.isNewUser) {
                    saveSocialPhoto(user.user);
                  } else {
                    print("nooo new user");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MainPageWrapper()),
                        (Route<dynamic> route) => false);
                  }
                } else {
                  errorDialog(
                    context,
                    "There seems to be problem with either Google authentication or your Google application is not responsive, Please try reinstalling/updating Google application",
                  );
                }
              });
            } else {
              checkBoxDialog();
            }
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(
              "assets/icons/google.png",
              alignment: Alignment.center,
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
          ),
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(UiIcons.facebook_circled,
                size: 40, color: Color(0xff3b5998)),
          ),
          onTap: () async {
            if (i) {
              AuthService().signInFacebook(context).then((user) {
                if (user != null) {
                  if (user.additionalUserInfo.isNewUser) {
                    print(user.additionalUserInfo.profile);
                    saveSocialPhoto(user.user);
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => MainPageWrapper()),
                      (Route<dynamic> route) => false);
                } else {
                  errorDialog(
                    context,
                    "There seems to be problem with either Facebook authentication or your Facebook application is not responsive, Please try reinstalling/updating Facebook application",
                  );
                }
              });
            } else {
              checkBoxDialog();
            }
          },
        ),
        InkWell(
          onTap: () async {
            if (i) {
              await AuthService().signInTwitter().then((user) {
                if (user != null) {
                  if (user.additionalUserInfo.isNewUser) {
                    print(user.additionalUserInfo.profile);
                    saveSocialPhoto(user.user);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MainPageWrapper()),
                        (Route<dynamic> route) => false);
                  }
                } else {
                  errorDialog(
                    context,
                    "There seems to be problem with either Twitter authentication or your Twitter application is not responsive, Please try reinstalling/updating Twitter application",
                  );
                }
              });
            } else {
              checkBoxDialog();
            }
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(UiIcons.twitter_circled,
                size: 40, color: Color(0xff1b98e4)),
          ),
        ),
      ],
    );
  }

  Widget _builderDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 2.0),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  String validateMobile(String phoneNo) {
    if (phoneNo.length != 10)
      return "Entered Number must be of 10 digit";
    else
      return null;
  }

  showErrorSocialMediaAuthenticate(String provider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Text(
              "There seems to be problem with either $provider authentication or your $provider application is not responsive",
              style: Theme.of(context).textTheme.display1,
            ),
          );
        });
  }

  checkBoxDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert !!!'),
          content: Text('Please check the terms and conditions'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Column(
                children: <Widget>[
                  Text('Ok'),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  saveSocialPhoto(FirebaseUser user) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Use this picture as your avatar?",
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    radius: 50,
                    child: (user != null)
                        ? Image(
                            image: CachedNetworkImageProvider(user.photoUrl),
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                            loadingBuilder: (context, child, data) {
                              if (data == null) {
                                return child;
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                        : Container(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          print(DatabaseService.uid);
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child(DatabaseService.uid)
                              .child("avatar.jpg");
                          CachedNetworkImageProvider(user.photoUrl);
                          Uint8List image =
                              await StorageService().imageToByte(user.photoUrl);
                          print(user.photoUrl);
                          StorageUploadTask task =
                              storageReference.putData(image);
                          await task.onComplete;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPageWrapper()),
                              (Route<dynamic> route) => false);
                        },
                        child: Icon(Icons.check),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        onPressed: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPageWrapper()),
                              (Route<dynamic> route) => false);
                        },
                        child: Icon(Icons.clear),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
