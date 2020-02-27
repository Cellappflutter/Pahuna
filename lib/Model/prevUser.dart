import 'package:flutter/cupertino.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';

class PrevUser with ChangeNotifier {
  bool prevUser = false;

  void setPrevUser() {
    this.prevUser = true;
    notifyListeners();
  }

  bool get isPrevUser => this.prevUser;
}
