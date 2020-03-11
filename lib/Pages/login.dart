import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';

import 'package:ecommerce_app_ui_kit/database/auth.dart';

import 'package:ecommerce_app_ui_kit/Model/settings.dart';

import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/Helper/error_helper.dart';
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
              )
            ],
          );
        });
  }

  signIn() async {
    pr.show();
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationID, smsCode: smsCode);
      AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await Prefs.setUserUid(authResult.user.uid);
        double range= await Prefs.getRangeData();
        double start= await Prefs.getStartAgeData();
        double end= await Prefs.getEndAgeData();
        DiscoverySetting.agePrefs=RangeValues(start, end);
        DiscoverySetting.range=range;
      DatabaseService.uid=authResult.user.uid;
      pr.dismiss();
      print(authResult.user.phoneNumber);
      print("Signed IN");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPageWrapper()),
          (Route<dynamic> route) => false);
    } catch (e) {
      verifyFailed(e);
    }
  }

  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 205, horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  margin: EdgeInsets.fromLTRB(
                    30,
                    230,
                    30,
                    20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text('Sign Up',
                          style: Theme.of(context).textTheme.display3),
                      SizedBox(height: 20),
                      CountryPickerDropdown(
                        initialValue: 'np',
                        itemBuilder: _builderDropdownItem,
                        onValuePicked: (Country country) {
                          print(
                              "${country.name}(+${country.phoneCode}) getting selected item");
                          setState(() {
                            holder = int.parse(country.phoneCode);
                          });
                        },
                      ),
                      new TextFormField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                        decoration: new InputDecoration(
                          hintText: 'Phone No.',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).accentColor),
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
                      SizedBox(height: 40),
                      FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 70),
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Alert !!!'),
                                  content: Text(
                                      'Please check the terms and conditions'),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenSizeConfig.safeBlockHorizontal * 8),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: i,
                      onChanged: (bool value) {
                        setState(() {
                          i = value;
                          print(value);
                        });
                      }),
                  Container(
                      width: ScreenSizeConfig.safeBlockHorizontal * 72,
                      child: RichText(
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text:
                                  "By using this application, you agree to Pahuna's ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms of Service and Privacy Notice.',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    // color: Color.fromRGBO(41, 128, 185, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(tos),
                                )
                              ]))),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Twitter Login"),
            ),
            RaisedButton(
              onPressed: () async {
                await AuthService().signInGoogle().then((onValue) {
                  if (onValue) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainPageWrapper()));
                  }
                });
              },
              child: Text("Google Login"),
            ),
          ],
        ),
      ),
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
}
