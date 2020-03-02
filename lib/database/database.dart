import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/Model/profile_preferences.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';

class DatabaseService {
  static String uid;
  final CollectionReference reference = Firestore.instance.collection("pahuna");
  final CollectionReference requestReference =
      Firestore.instance.collection("ConnectionRequest");

  Future<bool> checkPrevUser() async {
    try {
      await reference.document(uid).updateData({});
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<CurrentUserInfo> getUserData() {
    print(uid);
    print("------");
    return reference.document(uid).snapshots().map(_userInfoMap);
  }

  CurrentUserInfo _userInfoMap(DocumentSnapshot snapshot) {
    Map<dynamic, dynamic> data = snapshot.data['profile'];
    try{
      return CurrentUserInfo(
      age: data['age'] ?? 0,
      gender: data['gender'],
      name: data['name'],
      uid: snapshot.documentID,
      interest: data['interest'],
      continent: _continentValues(data),
      matchPrefs: _matchPrefsValues(data),
    );
    }
    catch(e){
      return CurrentUserInfo();
    }
  }

  Stream<List<UserData>> getOnlineUsers(CurrentUserInfo searchPrefsdata){
    print("Checkuser");
      Query q = reference;
      Query datatwo = _matchPrefsQuery(searchPrefsdata.matchPrefs, q);
      Query datathree = _matchContinentsQuery(searchPrefsdata.continent, datatwo);
      Query datafour = datathree.where("profile.interest",
          arrayContainsAny: searchPrefsdata.interest);
      return datafour.snapshots().map(_onlineUserList);
    
  }

  Query _matchPrefsQuery(List<dynamic> matchPrefs, Query dataone) {
    Query query;
    switch (matchPrefs.length) {
      case 1:
        {
          print("one");
          query = dataone.where("profile.matchPrefs." + matchPrefs[0],
              isEqualTo: true);
          return query;
        }
      case 2:
        {
          print("two");
          query = dataone
              .where("profile.matchPrefs." + matchPrefs[0], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[1], isEqualTo: true);
          return query;
        }
      case 3:
        {
          print("three");
          query = dataone
              .where("profile.matchPrefs." + matchPrefs[0], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[1], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[2], isEqualTo: true);
          return query;
        }
      case 4:
        {
          query = dataone
              .where("profile.matchPrefs." + matchPrefs[0], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[1], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[2], isEqualTo: true)
              .where("profile.matchPrefs." + matchPrefs[3], isEqualTo: true);
          return query;
        }
      default:
        return dataone;
    }
  }

  _matchContinentsQuery(List<dynamic> continent, Query dataone) {
    Query query;
    switch (continent.length) {
      case 1:
        {
          query = dataone.where("profile.continent." + continent[0],
              isEqualTo: true);
          break;
        }
      case 2:
        {
          query = dataone
              .where("profile.continent." + continent[0], isEqualTo: true)
              .where("profile.continent." + continent[1], isEqualTo: true);
          break;
        }
      case 3:
        {
          query = dataone
              .where("profile.continent." + continent[0], isEqualTo: true)
              .where("profile.continent." + continent[1], isEqualTo: true)
              .where("profile.continent." + continent[2], isEqualTo: true);
          break;
        }
      case 4:
        {
          query = dataone
              .where("profile.continent." + continent[0], isEqualTo: true)
              .where("profile.continent." + continent[1], isEqualTo: true)
              .where("profile.continent." + continent[2], isEqualTo: true)
              .where("profile.continent." + continent[3], isEqualTo: true);
          break;
        }
      case 5:
        {
          query = dataone
              .where("profile.continent." + continent[0], isEqualTo: true)
              .where("profile.continent." + continent[1], isEqualTo: true)
              .where("profile.continent." + continent[2], isEqualTo: true)
              .where("profile.continent." + continent[3], isEqualTo: true)
              .where("profile.continent." + continent[4], isEqualTo: true);
          break;
        }
      default:
        {
          return dataone;
        }
    }
    return query;
  }

  List<String> onlineStatus(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data['status'];
    }).toList();
  }

  updateLocation(Position position) async {
    try {
      return await reference.document(uid).updateData({
        "latitude": position.latitude,
        "longitude": position.longitude,
      });
    } catch (e) {
      return await reference.document(uid).setData({
        "latitude": position.latitude,
        "longitude": position.longitude,
      }, merge: true);
    }
  }

  setUserPrefs(SearchPrefsdata searchPrefsdata) async {
    try {
      return await reference.document(uid).updateData({
        "profile": _prefsProfileData(searchPrefsdata),
      });
    } catch (e) {
      return await reference.document(uid).setData({
        "profile": _prefsProfileData(searchPrefsdata),
      }, merge: true);
      // }
    }
  }

  _prefsProfileData(SearchPrefsdata searchPrefsdata) {
    Map<dynamic, dynamic> profileData = Map<dynamic, dynamic>();
    profileData['interest'] = searchPrefsdata.interest;
    profileData['continent'] = _setContinentPrefs(searchPrefsdata.continent);
    profileData['matchPrefs'] = _setMatchPrefs(searchPrefsdata.matchPrefs);
    return profileData;
  }

  updateUserProfile(CurrentUserInfo userInfo) async {
    try {
      return await reference.document(uid).updateData({
        "profile": _updateProfileData(userInfo),
      });
    } catch (e) {
      return await reference.document(uid).setData({
        "profile": _updateProfileData(userInfo),
      }, merge: true);
      // }
    }
  }

  _updateProfileData(CurrentUserInfo userInfo) {
    Map<dynamic, dynamic> profile = Map<dynamic, dynamic>();
    profile['age'] = userInfo.age;
    profile['name'] = userInfo.name;
    profile['gender'] = userInfo.gender;
    profile['interest'] = userInfo.interest;
    profile['matchPrefs'] = _setMatchPrefs(userInfo.matchPrefs);
    profile['continent'] = _setContinentPrefs(userInfo.continent);
    return profile;
  }

  _setContinentPrefs(List<dynamic> continent) {
    Map<dynamic, dynamic> continents = Map<dynamic, dynamic>();
    continents['Asian'] = continent.contains("Asian");
    continents['African'] = continent.contains("African");
    continents['European'] = continent.contains("European");
    continents['X1'] = continent.contains("X1");
    continents['X2'] = continent.contains("X2");
    return continents;
  }

  Map<dynamic, dynamic> _setMatchPrefs(List<dynamic> matchPrefs) {
    Map<dynamic, dynamic> newMatchPrefs = Map<dynamic, dynamic>();
    newMatchPrefs['Boy'] = matchPrefs.contains("Boy");
    newMatchPrefs['Couple'] = matchPrefs.contains("Couple");
    newMatchPrefs['Girl'] = matchPrefs.contains("Girl");
    newMatchPrefs['Group'] = matchPrefs.contains("Group");
    return newMatchPrefs;
  }

  updateStatus(String status) {
    try {
      reference.document(uid).updateData({
        "status": status,
      });
    } catch (e) {
      reference.document(uid).setData({
        "status": status,
      }, merge: true);
    }
  }

  List<UserData> _onlineUserList(QuerySnapshot snapshot) {
    if (snapshot.documents.length > 0) {
      List<UserData> _userData = List<UserData>();
      final document = snapshot.documents;
      document.forEach((doc) {
        if (doc.documentID.compareTo(uid) != 0) {
          _userData.add(UserData(
            name: doc.data['name'] ?? "null",
            latitude: doc.data['latitude'] ?? "null",
            longitude: doc.data['longitude'] ?? "null",
            uid: doc.documentID ?? "null",
            interest: _interestValues(doc.data['profile']),
            continent: _interestValues(doc.data['profile']),
            matchPrefs: _matchPrefsValues(doc.data['profile']) ?? "null",
          ));
        }
      });
      return _userData;
    } else
      return null;
  }

  List<dynamic> _interestValues(Map<dynamic, dynamic> data) {
    return data['interest'];
  }

  List<dynamic> _continentValues(Map<dynamic, dynamic> data) {
    List<dynamic> _list = List<dynamic>();
    Map<dynamic, dynamic> continents = data['continent'];
    print("d");
    print(continents);
    if (continents['Asian']) {
      _list.add('Asian');
    }
    if (continents['European']) {
      _list.add('European');
    }
    if (continents['African']) {
      _list.add('African');
    }
    if (continents['X1']) {
      _list.add('X1');
    }
    if (continents['X2']) {
      _list.add('X2');
    }
    return _list;
  }

  List<dynamic> _matchPrefsValues(Map<dynamic, dynamic> data) {
    List<dynamic> _list = List<dynamic>();
    Map<dynamic, dynamic> matchPrefs = data['matchPrefs'];
    if (matchPrefs['Girl']) {
      _list.add('Girl');
    }
    if (matchPrefs['Boy']) {
      _list.add('Boy');
    }
    if (matchPrefs['Group']) {
      _list.add('Group');
    }
    if (matchPrefs['Couple']) {
      _list.add('Couple');
    }
    return _list;
  }

  Stream<List<String>> getter() {
    return requestReference
        .document("TqYPZHH36e2T9GFiz8cp")
        .collection("Pending")
        .snapshots()
        .map(convert);
  }

  List<String> convert(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.documentID;
    }).toList();
  }

  putter() {
    requestReference.document("TqYPZHH36e2T9GFiz8cp").setData({
      "uid": ["six"].toList(),
    }, merge: true);
  }

  Future<void> sendReq(String user_id) async {
    return await requestReference
        .document(user_id) //end_user UID
        .collection("Pending")
        .document(uid) //currentUser UID
        .setData({"time": "timerrr"});
  }

  Future<bool> acceptReq(String user_id) async {
    try {
      await requestReference
          .document(user_id) //end_user UID
          .collection("Accepted")
          .document(uid) //currentUser UID
          .setData({"time": "timerrr"});
      await requestReference
          .document(uid) //end_user UID
          .collection("Accepted")
          .document(user_id) //currentUser UID
          .setData({"time": "timerrr"});
      await requestReference
          .document("TqYPZHH36e2T9GFiz8cp") //end_user UID
          .collection("Pending")
          .document(uid)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<RequestedUser>> getMatchRequest() {
    return requestReference
        .document(uid)
        .collection("Pending")
        .snapshots()
        .map(requestMapper);
  }

  List<RequestedUser> requestMapper(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return RequestedUser(uid: doc.documentID, time: doc.data['time']);
    }).toList();
  }
}
