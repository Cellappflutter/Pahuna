import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<bool> setIsFirstTime(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("isFirstTime", value);
  }

  static Future<bool> getIsFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isFirstTime") ?? true;
  }

  static Future<String> getUserUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("uid") ?? null;
  }

  static Future<bool> setUserUid(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("uid", value);
  }

  static Future<bool> setStartAgeData(double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setDouble("ageStart", value);
  }

  static Future<bool> setEndAgeData(double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setDouble("ageEnd", value);
  }

  static Future<bool> setRangeData(double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setDouble("Range", value);
  }

  static Future<double> getRangeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble("Range") ?? 8;
  }

  static Future<double> getStartAgeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble("ageStart") ?? 18;
  }

  static Future<double> getEndAgeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble("ageEnd") ?? 24;
  }

  static Future<bool> setLoggedIn(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("loggedIn", value);
  }

  static Future<bool> getLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("loggedIn") ?? false;
  }

  static Future<bool> removeAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }
}
