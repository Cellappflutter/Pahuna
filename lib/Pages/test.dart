
import 'package:ecommerce_app_ui_kit/Pages/Exit.dart';
import 'package:ecommerce_app_ui_kit/Pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class testpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = Provider.of<FirebaseUser>(context);
    //print(info.email);
    //print(info.displayName);
    if (info != null) {
        print(info.email);
    print(info.displayName);
   
       print(info.phoneNumber);
    print(info.uid);
      return ExitPage();
    } else
      return LoginPage();
  }
}
