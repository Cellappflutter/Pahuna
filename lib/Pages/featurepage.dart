import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:ecommerce_app_ui_kit/Pages/categories_tabs.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../src/models/review.dart';
import 'categories_tabs.dart';

class FeaturePage extends StatefulWidget {
  Featuredata featureData;
  // Post postData;
  FeaturePage({this.featureData});
  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  int indexWidget = 2;
  Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 800,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xFF2C2C2C),
                forceElevated: true,
                elevation: 10,
                centerTitle: true,
                expandedHeight: ScreenSizeConfig.safeBlockVertical * 40,
                pinned: true,
                stretch: true,
                floating: false,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    UiIcons.return_icon,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: Stack(
                  children: <Widget>[
                    FlexibleSpaceBar(
                      background: topImage(context),
                      collapseMode: CollapseMode.parallax,
                      title: Text(
                        widget.featureData.title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SliverStickyHeader(
                header: Container(
                  //  height: 60.0,
                  color: Colors.white.withOpacity(0.8),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Color(0xffdd2827),
                        highlightColor: Colors.yellow,
                        onPressed: () {
                          setState(() {
                            indexWidget = 0;
                          });
                        },
                        child: Text(
                          "Medias",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        color: Color(0xffdd2827),
                        onPressed: () {
                          setState(() {
                            indexWidget = 1;
                          });
                        },
                        child: Text(
                          "Information",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        color: Color(0xffdd2827),
                        onPressed: () {
                          setState(() {
                            indexWidget = 2;
                          });
                        },
                        child: Text(
                          "Reviews",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                sliver: getSliverWidgets(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  featuresChip(String title, void onTap()) {
    return Container(
      margin: EdgeInsets.only(left: appColors.App(context).appHeight(3)),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          color: appColors.Colors().mainColor(1),
          // splashColor: appColors.Colors().mainColor(1),
          onPressed: () {
            onTap();
          }),
    );
  }

  Widget topImage(BuildContext context) {
    return Container(
      // height: ScreenSizeConfig.safeBlockVertical * 30,
      //width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: <Widget>[
          (widget.featureData.image != null && widget.featureData.image != "")
              ? 
              Image(image:CachedNetworkImageProvider(widget.featureData.image),fit: BoxFit.fill,)
              // Image.network(
              //     widget.featureData.image,
              //     fit: BoxFit.fill,
              //   )
              : Image.asset(
                  "assets/user3.jpg",
                  fit: BoxFit.fill,
                ),
        ],
      ),
    );
  }

  getSliverWidgets() {
    switch (indexWidget) {
      case 0:
        {
          return (Medias_Tab());
        }
      case 1:
        {
          return Details_Tab(details: widget.featureData.content,);
        }
      case 2:
        {
          return (Review_tab());
        }
      default:
        {
          return Medias_Tab();
        }
    }
  }
}
