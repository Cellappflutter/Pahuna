import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title,
    {bool callShow}) {
  return PreferredSize(
      child: Container(
        // color: Colors.red,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 2)
        ]),
        child: Stack(
          //  mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: new Icon(UiIcons.return_icon,
                    color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            (callShow != null)
                ? Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: new Icon(Icons.call,
                          color: Theme.of(context).hintColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                : Container(),
          ],
        ),
        //         AppBar(
        //   automaticallyImplyLeading: false,
        //   leading: new IconButton(
        //     icon: new Icon(UiIcons.return_icon,
        //         color: Theme.of(context).hintColor),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: Text(
        //     'Requests',
        //     style: Theme.of(context).textTheme.display1,
        //   ),
        // ),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width * 100,
          ScreenSizeConfig.safeBlockHorizontal * 14));
}
