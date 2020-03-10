import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
   final String uid,message;
   final Timestamp timestamp;
  Message({this.uid,this.message,this.timestamp});
}