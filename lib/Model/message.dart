import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
   final String from,to,message;
   final Timestamp timestamp;
  Message({this.from,this.to,this.message,this.timestamp});
}