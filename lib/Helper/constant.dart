import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color pulsateColor = Colors.red;
const APP_ID = 'bfcfc5a9c3c74f42aba91658c4243845';

getHigherUid(String uid1, String uid2) {
  if (uid1.compareTo(uid2) > 0) {
    return uid1;
  }
  return uid2;
}
