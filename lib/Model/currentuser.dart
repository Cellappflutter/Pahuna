//import 'dart:ui';

import 'package:flutter/widgets.dart';

class CurrentUserInfo {
  String name;
  int age=18;
  List<dynamic> continent = List<dynamic>();
  List<dynamic> interest = List<dynamic>();
  List<dynamic> matchPrefs = List<dynamic>();
  String gender;
  String uid;
  String avatar;
  String email;
  String description;
  String phoneno;
  CurrentUserInfo(
      {this.uid,
      this.name,
      this.age,
      this.email,
      this.gender,
      this.continent,
      this.interest,
      this.avatar,
      this.description,
      this.phoneno,
      this.matchPrefs});
}
class Friendinfo{
  String name, uid, avatar;
  Friendinfo({this.name,this.uid,this.avatar});
}
