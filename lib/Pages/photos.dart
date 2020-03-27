import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPhotos extends StatefulWidget {
  final String userId;

  const UserPhotos({Key key, this.userId}) : super(key: key);
  @override
  _UserPhotosState createState() => _UserPhotosState();
}

class _UserPhotosState extends State<UserPhotos> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: DatabaseService().getUserPhotos("userId"),
      child: SafeArea(
        child: Scaffold(
          appBar: customAppBar(context, "Gallery"),
          body: Consumer<List<String>>(
            builder: (context, snapshot, child) {
              if (snapshot != null) {
                if (snapshot.length > 0) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      List<String> data = await DatabaseService()
                          .getUserPhotos("widget.userId");
                      setState(() {
                        snapshot = data;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                          itemCount: snapshot.length,
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
                                  imageUrl: snapshot[index],
                                  fit: BoxFit.fill,
                                  // height: ScreenSizeConfig.safeBlockVertical * 10,
                                  // width: ScreenSizeConfig.safeBlockVertical * 20,
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
                                            imageUrl: snapshot[index],
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
                } else {
                  return Center(
                    child: Text("No Photos Found in Gallery"),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

}
