import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:flutter/material.dart';

class Details_Tab extends StatefulWidget {
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
      delegate: SliverChildListDelegate([]),
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
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"
  ];
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildListDelegate([gridImages()]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
    );
  }
    gridImages(){
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
      }, childCount: url.length);
  }
}
