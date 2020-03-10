import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../Model/Data.dart';
import '../Model/Data.dart';
import '../Model/Data.dart';
import '../src/models/review.dart';
import '../src/models/review.dart';
import '../src/models/review.dart';
import '../src/widgets/ReviewItemWidget.dart';
import '../src/widgets/ReviewItemWidget.dart';

class Details_Tab extends StatefulWidget {
  final String details;
  Details_Tab({this.details});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Detail();
  }
}

class _Detail extends State<Details_Tab> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverList(
        delegate: SliverChildListDelegate([_description(widget.details)]));
  }

  _description(String detail) {
    var sth = parse(detail);
    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
              
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Icon(
                        UiIcons.file_1,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Description",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          )),
                    ])),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 5,right: 1),
                  // color: Colors.green,
                  child: Text(
                    sth.body.text,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),

          ),
        ],
      ),
    );
  }
}

class Medias_Tab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Media();
  }
}

class _Media extends State<Medias_Tab> {
  List<String> url = [
    "https://image.shutterstock.com/image-photo/mountains-during-sunset-beautiful-natural-260nw-407021107.jpg",
    "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&w=1000&q=80",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    "https://image.shutterstock.com/image-photo/mountains-during-sunset-beautiful-natural-260nw-407021107.jpg",
    "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&w=1000&q=80",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    "https://image.shutterstock.com/image-photo/mountains-during-sunset-beautiful-natural-260nw-407021107.jpg",
    "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&w=1000&q=80",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
  ];
  @override
  Widget build(BuildContext context) {
    return SliverGrid(


      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Hero(
          tag: "image" + index.toString(),
          child: InkWell(
              child: Image.network(
                url[index],
                fit: BoxFit.fill,
                loadingBuilder: (context, child, data) {
                  if (data == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                                tag: "image" + index.toString(),
                                child: Image.network(
                                  url[index],
                                  height:
                                      ScreenSizeConfig.safeBlockVertical * 50,
                                  fit: BoxFit.fill,
                                ))
                          ],
                        ),
                      );
                    });
              }),
        );
      }, childCount: url.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
    );

  }

  gridImages() {
    return SliverChildBuilderDelegate((BuildContext context, int index) {
      return Hero(
        tag: "image" + index.toString(),
        child: InkWell(
            child: Image.network(
              url[index],
              fit: BoxFit.fill,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                              tag: "image" + index.toString(),
                              child: Image.network(
                                url[index],
                                height: ScreenSizeConfig.safeBlockVertical * 50,
                                fit: BoxFit.fill,
                              ))
                        ],
                      ),
                    );
                  });
            }),
      );
    }, childCount: url.length);

  }
}

class Review_tab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _review();
  }
}

class _review extends State<Review_tab> {
  @override
  Widget build(BuildContext context) {
    List<Reviewdata> reviewdata = [
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '10:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '11:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '12:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '13:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '11:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '12:00',
          rating: '4',
          url_image: 'img/user1.jpg'),
      Reviewdata(
          username: 'Pratik',
          review: 'Not bad',
          date_time: '13:00',
          rating: '4',
          url_image: 'img/user1.jpg')
    ];
    // TODO: implement build
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return _listreview(reviewdata[index]);
    }, childCount: reviewdata.length));
  }

  _listreview(Reviewdata data) {
    return ReviewItemWidget(
        url: data.url_image,
        username: data.username,
        rating: data.rating,
        review: data.review,
        date_time: data.date_time);
  }
}
