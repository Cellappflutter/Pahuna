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
    return Container(
      child: Text("Description Page"),
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
    return Container(
      child: GridView.builder(
        physics: new NeverScrollableScrollPhysics(),
        //  primary: true,
          itemCount: url.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
          itemBuilder: (BuildContext context, index) {
            return ClipRRect(
              //  borderRadius: BorderRadius.circular(60),
              child: AspectRatio(
                aspectRatio: 14 / 16,
                child: Image.network(
                  url[index],
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
    );
  }
}
