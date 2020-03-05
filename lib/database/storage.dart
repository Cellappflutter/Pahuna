import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';

class StorageService {
  String uid = 'hhhhh';
  StorageService() {
    this.uid = DatabaseService.uid;
  }

  StorageReference storageReference = FirebaseStorage.instance.ref();

  uploadUserAvatar(File _image) async {
    //String fileName = _image.path.split('/').removeLast();
    StorageReference imageRef = storageReference.child(uid).child("avatar.jpg");
    StorageUploadTask task = imageRef.putFile(_image);
    return await task.onComplete;
  }

  Future<String> getUserAvatar() async {
    try {
      print("11111111111111111111111111");
      return await storageReference
          .child(uid)
          .child('avatar.jpg')
          .getDownloadURL();
    } catch (e) {
      print("22222222222222222222222222222");
      return "";
    }
  }

  Future<CurrentUserInfo> getFullDataAvatar(CurrentUserInfo userInfo) async {
    userInfo.avatar = await getAvatar(userInfo.uid);
    return userInfo;
  }

  Future<String> getAvatar(String userid) async {
    try {
      return await storageReference
          .child(userid)
          .child('avatar.jpeg')
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<List<RequestedUser>> getAvatarList(List<RequestedUser> data) async {
    print("dssdsd");
    for (int i = 0; i < data.length; i++) {
      data[i].avatar = await getAvatar(data[i].uid);
      // print(data[i].avatar);
    }
    return data;
  }
}
