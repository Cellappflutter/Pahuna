import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/review.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReviewItemWidget extends StatelessWidget {
  String url, username, rating, review, date_time;
  ReviewItemWidget(
      {this.date_time, this.rating, this.review, this.url, this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: Colors.blueGrey)),
        child: Wrap(
          direction: Axis.horizontal,
          runSpacing: 15,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                        image: AssetImage("img/user1.jpg"), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  username,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(
                                          color: Theme.of(context).hintColor)),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      UiIcons.calendar,
                                      color: Theme.of(context).focusColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      date_time,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Chip(
                            padding: EdgeInsets.all(0),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(rating,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor))),
                                Icon(
                                  Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 25,
                                ),
                              ],
                            ),
                            backgroundColor:
                                Theme.of(context).accentColor.withOpacity(1),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(height: 18),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Dialog(
                        // backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                              tag: 'text',
                              child: Text(
                                review,
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        // child: Container(
                        //   // height: MediaQuery.of(context).size.height,
                        //   // height: ,
                        //   decoration: BoxDecoration(
                        //     // borderRadius: BorderRadius.only(
                        //     //   bottomRight: Radius.circular(10.0),
                        //     //   topLeft: Radius.circular(10.0),
                        //     // ),
                        //     borderRadius: BorderRadius.circular(18.0),
                        //   ),
                        //   child: Center(
                        //     child: Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           review,
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               letterSpacing: 2,
                        //               fontWeight: FontWeight.w500),
                        //         )),
                        //   ),
                        // ),
                      );
                    });
              },
              child: Text(
                review,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
              ),
            ),
            // Divider(color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
