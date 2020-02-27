import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';

class StorageService {
  static final String uid = DatabaseService.uid;

  StorageReference storageReference = FirebaseStorage.instance.ref();

  uploadUserAvatar(File _image) async {
    //String fileName = _image.path.split('/').removeLast();
    StorageReference imageRef =
        storageReference.child(uid).child("avatar.jpeg");
    StorageUploadTask task = imageRef.putFile(_image);
    return await task.onComplete;
  }

  Future<String> getUserAvatar() async {
    try {
      return await storageReference
          .child(uid)
          .child('avatar.jpeg')
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<String> getAvatar(String uid) async {
    try {
      return await storageReference
          .child(uid)
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
