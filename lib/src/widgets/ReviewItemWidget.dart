import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/review.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReviewItemWidget extends StatelessWidget {
  String url,username,rating,review,date_time;
  ReviewItemWidget({this.date_time,this.rating,this.review,this.url,this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 10,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(image: AssetImage("img/user1.jpg"), fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 15),
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
                                    .merge(TextStyle(color: Theme.of(context).hintColor)),
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
                                    style: Theme.of(context).textTheme.caption,
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
                                      .merge(TextStyle(color: Theme.of(context).primaryColor))),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 16,
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(
            review,
            style: Theme.of(context).textTheme.body1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 3,
          ),
  Divider(color: Colors.white,)
        ],
      ),
    );
  }
}
