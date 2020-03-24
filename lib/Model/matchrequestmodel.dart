import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedUser {
  String uid;
  Timestamp time;
  String avatar;
  String name;
  RequestedUser({this.uid, this.time, this.avatar, this.name});
}
