import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/message.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatefulWidget {
  final fid, name, avatar;
  ChatWidget({this.fid, this.name, this.avatar});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _chat();
  }
}

class _chat extends State<ChatWidget> {
  //final AuthService _authService = AuthService();
  final DatabaseService messageService = DatabaseService();
  final TextEditingController message = TextEditingController();
  BubbleStyle styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    elevation: 5,
    margin: BubbleEdges.only(top: 8.0, right: 50.0),
    alignment: Alignment.topLeft,
  );

  BubbleStyle styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 225, 255, 199),
    elevation: 5,
    margin: BubbleEdges.only(top: 8.0, left: 50.0),
    alignment: Alignment.topRight,
  );
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>.value(
      value: DatabaseService().tomessages(widget.fid),
      child: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, widget.name),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Consumer<List<Message>>(
                  builder: (context, value, child) {
                    if (value != null) {
                      return SingleChildScrollView(
                        child: Container(
                          height: ScreenSizeConfig.safeBlockVertical * 85,
                          child: ListView.builder(
                              reverse: false,
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                print("fid:::::::::::::receive");
                                print(widget.fid);
                                print(widget.fid.hashCode);
                                if (value[index].uid == widget.fid) {
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: ScreenSizeConfig
                                                  .safeBlockVertical *
                                              1,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Bubble(
                                          style: styleSomebody,
                                          child: Text(value[index].message),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Bubble(
                                    style: styleMe,
                                    child: Text(value[index].message),
                                  );
                                }
                              }),
                        ),
                      );
                    } else
                      return Container(
                        child: Text("LOADING.."),
                      );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: config.Colors().whiteColor(1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, -4),
                          blurRadius: 10)
                    ],
                  ),
                  child: Container(
                    height: 50,
                    child: TextField(
                      controller: message,
                      style: TextStyle(color: config.Colors().mainColor(1)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: 'Chat text here',
                        hintStyle: TextStyle(
                            color:
                                config.Colors().mainColor(1).withOpacity(0.5)),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.only(right: 30),
                          onPressed: () {
                            messageService.sendMessage(
                                message.text, widget.fid);
                            Timer(Duration(milliseconds: 100), () {
                              message.clear();
                            });
                          },
                          icon: Icon(
                            UiIcons.cursor,
                            color: config.Colors().mainColor(1),
                            size: 30,
                          ),
                        ),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
