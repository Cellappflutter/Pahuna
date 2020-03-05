import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:flutter/material.dart';

class FeaturePage extends StatefulWidget {
  // Post postData;
  // FeaturePage({this.postData});
  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                elevation: 10,
                centerTitle: true,
                expandedHeight: ScreenSizeConfig.safeBlockVertical * 40,
                pinned: true,
                stretch: true,
                floating: false,
                leading: Icon(UiIcons.return_icon),
                flexibleSpace: FlexibleSpaceBar(
                  background: topImage(context),
                  collapseMode: CollapseMode.parallax,
                  title: Text("widget.post.title.rendered"),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(widgets())),
              // SliverChildBuilderDelegate(
              //   (context, index) {
              //     return ListTile(
              //       title: Text("dssd"),
              //     );
              //   },childCount: 8,
              // ),),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> widgets() {
    return [Text("ds")];
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
          Image.asset(
            "assets/user3.jpg",
            fit: BoxFit.fill,
          ),
          // Image.network(widget.postData.featuredmedia.sourceUrl),
          // Align(
          //     alignment: Alignment.topLeft, child: Icon(UiIcons.return_icon)),
        ],
      ),
    );
  }
}
