import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/chat.dart';
import 'package:ecommerce_app_ui_kit/src/models/conversation.dart' as model;
import 'package:ecommerce_app_ui_kit/src/models/user.dart';
import 'package:ecommerce_app_ui_kit/src/screens/chat.dart';
import 'package:flutter/material.dart';

class MessageItemWidget extends StatefulWidget {
  BuildContext context1;
  MessageItemWidget({Key key, this.name,this.avatar, this.onDismissed,this.context1}) : super(key: key);
String message ="some text";
  String name, avatar;
  ValueChanged<String> onDismissed;

  @override
  _MessageItemWidgetState createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.message.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed(widget.message);
        });

        // Then show a snackbar.
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("The conversation with ${widget.name} is dismissed")));
      },
      child: InkWell(
        onTap: () {
        //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatWidget( context2: widget.context1,)));
        },
        child: Container(
          color: true ? Colors.transparent : Theme.of(context).focusColor.withOpacity(0.15),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("img/user1.jpg"),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 3,
                  //   right: 3,
                  //   width: 12,
                  //   height: 12,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: widget.message.user.userState == UserState.available
                  //           ? Colors.green
                  //           : widget.message.user.userState == UserState.away ? Colors.orange : Colors.red,
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Name",//this.widget.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.body2,
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: Text(
                    //         //this.widget.message.chats[0].text,
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 2,
                    //         style: Theme.of(context).textTheme.caption.merge(
                    //            // TextStyle(fontWeight: this.widget.message.read ? FontWeight.w300 : FontWeight.w600)),
                    //       ),
                    //     ),
                    //     Text(
                    //       this.widget.message.chats[0].time,
                    //       overflow: TextOverflow.fade,
                    //       softWrap: false,
                    //       style: Theme.of(context).textTheme.body1,
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
