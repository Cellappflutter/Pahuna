import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:flutter/material.dart';
import 'package:grafpix/pixloaders/pix_loader.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog loadingBar(BuildContext context, String message) {
  ProgressDialog pr = new ProgressDialog(context,
      isDismissible: false, type: ProgressDialogType.Download);
  pr.style(
      message: message,
      borderRadius: ScreenSizeConfig.blockSizeHorizontal * 5,
      backgroundColor: Colors.white,
      progressWidget: Center(
        child: PixLoader(
          faceColor: Colors.red,
          duration: 10,
          widthRatio: 0.15,
          loaderType: LoaderType.Spinner,
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.bounceInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black,
          fontSize: ScreenSizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: ScreenSizeConfig.blockSizeHorizontal * 6,
          fontWeight: FontWeight.w600));
  return pr;
}

errorDialog(BuildContext context, String message) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
