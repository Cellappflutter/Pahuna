
import 'package:ecommerce_app_ui_kit/Helper/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    return await _auth.signOut();
  }
}
