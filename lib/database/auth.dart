import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/settings.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_authUser);
  }

  FirebaseUser _authUser(FirebaseUser user) {
    return user;
  }

  Future<bool> signInGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication authentication =
            await account.authentication;
        await Prefs.setEmailID(account.email);
        AuthResult result = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: authentication.idToken,
                accessToken: authentication.accessToken));
        double range = await Prefs.getRangeData();
        double start = await Prefs.getStartAgeData();
        double end = await Prefs.getEndAgeData();
        DiscoverySetting.agePrefs = RangeValues(start, end);
        DiscoverySetting.range = range;
        DatabaseService.uid = result.user.uid;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await Prefs.removeAll();
    await DatabaseService().setOfflineStatus();
    return await _auth.signOut();
  }
}
