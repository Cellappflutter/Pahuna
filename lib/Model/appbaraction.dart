import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';

class AppBarActions extends StatelessWidget {
  final IconData uiIcon;
  final Function onTap;
  final double size = 30.0;

  const AppBarActions({Key key, this.uiIcon, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
        child: InkWell(
            borderRadius: BorderRadius.circular(300),
            onTap: onTap,
            child: Icon(
              uiIcon,
              color: appColors.Colors().accentColor(1),
            )));
  }
}
