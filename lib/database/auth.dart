import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_authUser);
  }

  FirebaseUser _authUser(FirebaseUser user) {
    return user;
  }

  Future<FirebaseUser> signInGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      GoogleSignInAuthentication authentication = await account.authentication;
      await Prefs.setEmailID(account.email);
      AuthResult result = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: authentication.idToken,
              accessToken: authentication.accessToken));
      await dataInit(result);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  dataInit(AuthResult result) async {
    double range = await Prefs.getRangeData();
    double start = await Prefs.getStartAgeData();
    double end = await Prefs.getEndAgeData();
    DiscoverySetting.agePrefs = RangeValues(start, end);
    DiscoverySetting.range = range;
    DatabaseService.uid = result.user.uid;
  }

  Future<FirebaseUser> signInTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'Dg20SCK8gwBI7k02m2RzW4VTL ',
      consumerSecret: 'GJh8NYa7D2XnCsdNBpZ4mCmR1TWP0kGJ6u3bxr4Kts3nSBiuHs',
    );
    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        {
          var session = result.session;
          AuthResult fresult = await _auth.signInWithCredential(
              TwitterAuthProvider.getCredential(
                  authToken: session.token, authTokenSecret: session.secret));
          print(fresult.user);
          await dataInit(fresult);
          return fresult.user;
          //  break;
        }
      case TwitterLoginStatus.cancelledByUser:
        {
          //   _showCancelMessage();
          return null;
          // break;
        }
      case TwitterLoginStatus.error:
        {
          return null;
          // _showErrorMessage(result.error);
          //   break;
        }
    }
    return null;
  }

  Future<void> signOut() async {
    await Prefs.removeAll();
    await DatabaseService().setOfflineStatus();
    await GoogleSignIn().signOut();
    return await _auth.signOut();
  }
}
