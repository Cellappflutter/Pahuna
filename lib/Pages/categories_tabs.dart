import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../Model/Data.dart';
import '../src/widgets/ReviewItemWidget.dart';

class Details_Tab extends StatefulWidget {
  final String details;
  Details_Tab({this.details});
  @override
  State<StatefulWidget> createState() {
    return _Detail();
  }
}

class _Detail extends State<Details_Tab> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height*0.7,
        child: SingleChildScrollView(
          child: _description(widget.details),
        ),
      
    );
  }

  _description(String detail) {
    var sth = parse(detail);
    return Container(
      margin: EdgeInsets.all(2),
      child: 
      Column(
              children: <Widget>[
                Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Icon(
                        UiIcons.file_1,
                        size: 25,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          margin: EdgeInsets.all(19),
                          child: Text(
                            "Description",
                            style: TextStyle(fontSize: 23, color: Colors.red,fontWeight: FontWeight.w800),
                          )),
                    ])),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 5, right: 1),
                  // color: Colors.green,
                  child: Text(
                    sth.body.text,
                    style: TextStyle(color: Colors.red,fontSize: 18.0,letterSpacing: 2,fontWeight: FontWeight.w600),
                  ),
                )])
    );
  }
}

class Medias_Tab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
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
              child:
                  // Image.network(
                  Image(
                image: CachedNetworkImageProvider(url[index]),
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
                              child: Image(
                                image: CachedNetworkImageProvider(url[index]),
                                height: ScreenSizeConfig.safeBlockVertical * 50,
                                fit: BoxFit.fill,
                              ),
                              // Image.network(
                              //   url[index],
                              //   height: ScreenSizeConfig.safeBlockVertical * 50,
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                          ],
                        ),
                      );
                    });
              }),
        );
      }, childCount: url.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 19,
        mainAxisSpacing: 19,
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
    );
  }

  gridImages() {
    return SliverChildBuilderDelegate((BuildContext context, int index) {
      return Hero(
        tag: "image" + index.toString(),
        child: InkWell(
            child: Image(
              image: CachedNetworkImageProvider(url[index]),
              fit: BoxFit.fill,
            ),
            // Image.network(
            //   url[index],
            //   fit: BoxFit.fill,
            // ),
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
                            child: Image(
                                image: CachedNetworkImageProvider(url[index]),
                                height: ScreenSizeConfig.safeBlockVertical * 50,
                                fit: BoxFit.fill),
                            // Image.network(
                            //   url[index],
                            //   height: ScreenSizeConfig.safeBlockVertical * 50,
                            //   fit: BoxFit.fill,
                            // ),
                          )
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
          review: 'Not bad, it is very good, i like to move it move it, you like to move it move it, we like to move it, physically fit, physically fit, Not bad, it is very good, i like to move it move it, you like to move it move it, we like to move it, physically fit, physically fit, Not bad, it is very good, i like to move it move it, you like to move it move it, we like to move it, physically fit, physically fit, ',
          date_time: '10:00',
          rating: '5',
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
    return Container(
      height: MediaQuery.of(context).size.height*0.7,
          child: ListView.builder(
        itemCount: reviewdata.length,
        itemBuilder: (context,item){
          return _listreview(reviewdata[item]);
        }),
    );
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
