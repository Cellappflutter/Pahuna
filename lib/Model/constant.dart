import 'package:flutter/cupertino.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:connectivity/connectivity.dart';

class AppColors {
  static final double pageheight = ScreenSizeConfig.blockSizeVertical * 85;
  static final double fontSize = ScreenSizeConfig.blockSizeHorizontal * 7;
  static final Color backgroundColor = Color(0xFF4A4A58);
  static ConnectivityResult connection;
}
