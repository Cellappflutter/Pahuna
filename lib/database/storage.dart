import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  String uid;
  StorageService() {
    this.uid = DatabaseService.uid;
  }

  StorageReference storageReference = FirebaseStorage.instance.ref();

  uploadUserAvatar(File _image) async {
    StorageReference imageRef = storageReference.child(uid).child("avatar.jpg");
    StorageUploadTask task = imageRef.putFile(_image);
    return await task.onComplete;
  }

  Future<String> getUserAvatar() async {
    try {
      return await storageReference
          .child(uid)
          .child('avatar.jpg')
          .getDownloadURL();
    } catch (e) {
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
          .child('avatar.jpg')
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<List<RequestedUser>> getAvatarList(List<RequestedUser> data) async {
    for (int i = 0; i < data.length; i++) {
      data[i].avatar = await getAvatar(data[i].uid);
    }
    return data;
  }

  Future<Uint8List> imageToByte(String path) async {
    HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(path));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }

  Future<bool> uploadImage(File _image, String fileName) async {
    try {
      print(_image);
      StorageReference imageRef = storageReference.child(uid).child(fileName);
      StorageUploadTask task = imageRef.putFile(_image);
      await task.onComplete;
      print('object');
      return true;
    } catch (e) {
      print("object");
      return false;
    }
  }

  Future<String> getUserImage(String image, String userId) async {
    try {
      return await storageReference.child(userId).child(image).getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  Future<List<String>> getAllUserImage(
      List<dynamic> images, String userId) async {
    List<String> newData = [];
    for (dynamic image in images) {
      newData.add(await getUserImage(image.toString(), userId));
    }
    return newData;
  }
}
