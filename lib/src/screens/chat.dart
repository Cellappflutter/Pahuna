import 'dart:async';

import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/chat.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart'as config;
import 'package:ecommerce_app_ui_kit/src/models/conversation.dart';
import 'package:ecommerce_app_ui_kit/src/models/user.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/ChatMessageListItemWidget.dart';
import 'package:flutter/material.dart';


class ChatWidget extends StatefulWidget {
  final BuildContext context2;
  ChatWidget({this.context2});
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  ConversationsList _conversationList = new ConversationsList();
  User _currentUser = new User.init().getCurrentUser();
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: customAppBar(widget.context2, "Chat"),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: AnimatedList(
                key: _myListKey,
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                initialItemCount: _conversationList.conversations[0].chats.length,
                itemBuilder: (context, index, Animation<double> animation) {
                  Chat chat = _conversationList.conversations[0].chats[index];
                  return ChatMessageListItem(
                    chat: chat,
                    animation: animation,
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: config.Colors().whiteColor(1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), offset: Offset(0, -4), blurRadius: 10)
                ],
              ),
              child: TextField(
                controller: myController,
                style: TextStyle(color: config.Colors().mainColor(1)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Chat text here',
                  hintStyle: TextStyle(color: config.Colors().mainColor(1).withOpacity(0.5)),
                  
                  suffixIcon: IconButton(
                    padding: EdgeInsets.only(right: 30),
                    onPressed: () {
                      setState(() {
                        _conversationList.conversations[0].chats
                            .insert(0, new Chat(myController.text, '21min ago', _currentUser));
                        _myListKey.currentState.insertItem(0);
                      });
                      Timer(Duration(milliseconds: 100), () {
                        myController.clear();
                      });
                    },
                    icon: Icon(
                      UiIcons.cursor,
                      color: config.Colors().mainColor(1),
                      size: 30,
                    ),
                  ),
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
