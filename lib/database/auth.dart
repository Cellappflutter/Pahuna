import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_authUser);
  }

  FirebaseUser _authUser(FirebaseUser user) {
    return user;
  }

  Future<void> signOut() async {
    await Prefs.removeAll();
    await DatabaseService().setOfflineStatus();
    await FacebookLogin().logOut();
    return await _auth.signOut();
  }

   Future<void> facebooklogin()async{
    FacebookLogin fbLogin = FacebookLogin();
    fbLogin.logInWithReadPermissions(
      ['email','public_profile']).then((result){
        switch (result.status) {
          case FacebookLoginStatus.loggedIn:
          _auth.signInWithCredential(
            FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token))
              .then((signedInUser){
                print(signedInUser.user.photoUrl);
                print('Signed in as ${signedInUser}');
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(
                //     builder: (context)=>MainPageWrapper()),
                //     (Route<dynamic> route) => false);
              }).catchError((e){
                print(e);
              });
            
            break;
          default:
        }
      });
  }
}
