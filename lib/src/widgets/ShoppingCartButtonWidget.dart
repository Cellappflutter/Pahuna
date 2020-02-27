import 'dart:ui';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/screens/cart.dart';
import 'package:flutter/material.dart';

class ShoppingCartButtonWidget extends StatelessWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    this.labelCount = 0,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final int labelCount;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CartWidget()));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              UiIcons.user_3,
              color: this.iconColor,
              size: 30,
            ),
          ),
          Container(
            child: Text(
              this.labelCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(color: config.Colors().whiteColor(1), fontSize: 12),
                  ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: config.Colors().mainColor(1), borderRadius: BorderRadius.all(Radius.circular(14))),
            constraints: BoxConstraints(minWidth: 17, maxWidth: 17, minHeight: 17, maxHeight: 17),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
