import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Pages/Camera.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPhotos extends StatefulWidget {
  final String userId;

  const UserPhotos({this.userId});
  @override
  _UserPhotosState createState() => _UserPhotosState();
}

class _UserPhotosState extends State<UserPhotos> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  List<String> images;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Gallery"),
        floatingActionButton: FloatingActionButton(
          mini: false,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CameraState()));
          },
          heroTag: "tagger",
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<List<String>>(
          future: DatabaseService().getUserPhotos(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  images = snapshot.data;

                  return RefreshIndicator(
                    onRefresh: () async {
                      List<String> data =
                          await DatabaseService().getUserPhotos(widget.userId);

                      setState(() {
                        images = data;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data[index],
                                  fit: BoxFit.fill,
                                  errorWidget: (context, data, child) {
                                    return Image.asset(
                                      "assets/placeholder.png",
                                      fit: BoxFit.fill,
                                    );
                                  },
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data[index],
                                            fit: BoxFit.fill,
                                            height: ScreenSizeConfig
                                                    .safeBlockVertical *
                                                50,
                                            width: ScreenSizeConfig
                                                    .safeBlockVertical *
                                                50,
                                          ),
                                        ),
                                      );
                                    });
                              },
                            );
                          }),
                    ),
                  );
                }
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/nophotos.png",
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: ScreenSizeConfig.safeBlockVertical * 5),
                      Text(
                        "These would look beautiful with your pictures",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 1.8,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
