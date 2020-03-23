import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Pages/callpage.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title,
    {bool callShow, String uid}) {
  return PreferredSize(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 2)
        ]),
        child: Stack(
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
            (callShow ?? false)
                ? Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: new Icon(Icons.call,
                          color: Theme.of(context).hintColor),
                      onPressed: () async {
                        await handleCameraAndMic();
                        await DatabaseService().enableUserReceiveCall(uid);
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => CallPage(
                                      channelName: uid,
                                    )))
                            .then((onValue) async {
                          await DatabaseService().onCallEnd();
                        });
                      },
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
  Future<void> handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
