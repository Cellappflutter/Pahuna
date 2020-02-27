import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';


class UserDialog extends StatelessWidget {
  final UserData info;
  final double avatarRadius = ScreenSizeConfig.blockSizeHorizontal * 12;

  UserDialog({
    @required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[dialogContent(context)],
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: ScreenSizeConfig.safeBlockVertical*25),
      child: Stack(
        children: <Widget>[
          infoCard(context),
          avatarCard(),
        ],
      ),
    );
  }

  avatarCard() {
    return Align(
      alignment: Alignment.topCenter,
      child: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: avatarRadius,
      ),
    );
  }

  infoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: avatarRadius),
      margin: EdgeInsets.only(top: avatarRadius),
      decoration: new BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.rectangle,
        borderRadius:
            BorderRadius.circular(ScreenSizeConfig.safeBlockHorizontal * 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            info.uid,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: ScreenSizeConfig.safeBlockHorizontal * 4),
          Text(
            info.distance.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: ScreenSizeConfig.blockSizeVertical * 4),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
              },
              child: Text("Yes"),
            ),
          ),
          SizedBox(height: ScreenSizeConfig.safeBlockHorizontal * 4),
        ],
      ),
    );
  }
}
