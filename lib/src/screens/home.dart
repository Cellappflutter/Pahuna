import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:ecommerce_app_ui_kit/Pages/featurepage.dart';
import 'package:ecommerce_app_ui_kit/database/Word.dart';
import 'package:ecommerce_app_ui_kit/src/models/product.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/brand.dart';
import 'package:ecommerce_app_ui_kit/src/models/category.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/Hometop.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  CategoriesList _categoriesList = new CategoriesList();
  BrandsList _brandsList = new BrandsList();

  Animation animationOpacity;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appColors.App(context);
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBarWidget(),
        ),
        Hometop(),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              UiIcons.favorites,
              color: appColors.Colors().accentColor(1),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Categories", style: Theme.of(context).textTheme.display1),
          ],
        ),
        SizedBox(height: 10),
        Consumer<List<Featuredata>>(builder: (context, snapshot, child) {
          if (snapshot != null) {
            return Wrap(
              children: featureChipDesign(snapshot),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ],
    );
  }

  List<Widget> featureChipDesign(List<Featuredata> data) {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < data.length; i++) {
      widgets.add(featuresChip(
        data[i].title.toString(),
        data[i],
      ));
    }
    return widgets;
  }

  featuresChip(
    String title,
    Featuredata data,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      margin: EdgeInsets.only(
          left: appColors.App(context).appHeight(1),
          right: appColors.App(context).appHeight(1)),
      child: Column(
        children: <Widget>[
          Card(
            elevation: (20.2),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 160,
                    child: data.image != null
                        ? Image.network(
                            data.image,
                            // cacheHeight: 140,
                            fit: BoxFit.cover,
                            height: 140,
                            // width: 170,
                          )
                        : Image.network("assets/brokenimage.png",
                            fit: BoxFit.cover, height: 140),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: appColors.Colors().mainColor(1),
                    onPressed: () {
                      print("datacheck");
                      print(data.content);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FeaturePage(featureData: data)));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
