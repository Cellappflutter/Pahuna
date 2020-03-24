import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/UiHelper/tinder_Card.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class newConnectionRequest extends StatefulWidget {
  final List<RequestedUser> requestedUser;
  final String name;

  const newConnectionRequest({Key key, this.requestedUser, this.name})
      : super(key: key);
  @override
  _newConnectionRequestState createState() => _newConnectionRequestState();
}

class _newConnectionRequestState extends State<newConnectionRequest>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: new TinderSwapCard(
            orientation: AmassOrientation.BOTTOM,
            totalNum: (widget.requestedUser != null)
                ? widget.requestedUser.length
                : 1,
            stackNum: 3,
            swipeEdge: 4.0,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  FutureBuilder(
                      future: StorageService()
                          .getAvatar(widget.requestedUser[index].uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != '') {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data,
                              height: MediaQuery.of(context).size.height * 0.6,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.asset("assets/placeholder.png",
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.6);
                          }
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, left: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          onTap: () {
                            controller.triggerLeft();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            controller.triggerRight();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, left: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            cardController: controller = CardController(),
            swipeCompleteCallback:
                (CardSwipeOrientation orientation, int index) async {
              if (orientation == CardSwipeOrientation.LEFT) {
                if (widget.name != null) {
                  await DatabaseService().acceptReq(
                      widget.requestedUser[index].uid,
                      widget.requestedUser[index].name,
                      widget.name ?? DatabaseService.uid);
                }
                checkLastIndex(index);
              }
              if (orientation == CardSwipeOrientation.RIGHT) {
                await DatabaseService()
                    .seenReq(widget.requestedUser[index].uid);
                checkLastIndex(index);
              }
            },
          ),
        ),
      ),
    );
  }

  checkLastIndex(int index) {
    if (index == (widget.requestedUser.length - 1)) {
      Navigator.of(context).pop();
    }
  }
}
