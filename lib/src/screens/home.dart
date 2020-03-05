import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/database/Word.dart';
import 'package:ecommerce_app_ui_kit/src/models/product.dart';

import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/src/models/brand.dart';
import 'package:ecommerce_app_ui_kit/src/models/category.dart';
import 'package:ecommerce_app_ui_kit/src/models/product.dart';
import 'package:ecommerce_app_ui_kit/src/widgets/CategorizedProductsWidget.dart';

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
  List<Product> _productsOfCategoryList;
  List<Product> _productsOfBrandList;

  CategoriesList _categoriesList = new CategoriesList();
  BrandsList _brandsList = new BrandsList();
  ProductsList _productsList = new ProductsList();

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
    _productsOfCategoryList = _categoriesList.list.firstWhere((category) {
      return category.selected;
    }).products;

    _productsOfBrandList = _brandsList.list.firstWhere((brand) {
      return brand.selected;
    }).products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appColors.App(context);
    //Wordget().word();
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBarWidget(),
        ),
        Hometop(),
        FutureBuilder<List<Featuredata>>(
            future: Wordget().word(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Center(
                    child: Wrap(
                      children: <Widget>[
                        
                        ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return
featuresChip(snapshot.data[index].id.toString(), () {Navigator.of(context).push(MaterialPageRoute(builder:(context)=>CategorizedProductsWidget()));});
                          })
                        
                      
                      ],
                    ),
                  );
                } else {
                  return Text("no Data");
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
        //  FlashSalesHeaderWidget(),
        //   FlashSalesCarouselWidget(heroTag: 'home_flash_sales', productsList: _productsList.flashSalesList),
        // Heading (Recommended for you)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.favorites,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Recommended For You',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        // StickyHeader(
        //   header: CategoriesIconsCarouselWidget(
        //       heroTag: 'home_categories_1',
        //       categoriesList: _categoriesList,
        //       onChanged: (id) {
        //         setState(() {
        //           animationController.reverse().then((f) {
        //             _productsOfCategoryList = _categoriesList.list.firstWhere((category) {
        //               return category.id == id;
        //             }).products;
        //             animationController.forward();
        //           });
        //         });
        //       }),
        //   content: CategorizedProductsWidget(animationOpacity: animationOpacity, productsList: _productsOfCategoryList),
        // ),
        // Heading (Brands)

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //   child: ListTile(
        //     dense: true,
        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
        //     leading: Icon(
        //       UiIcons.flag,
        //       color: Theme.of(context).hintColor,
        //     ),
        //     title: Text(
        //       'Brands',
        //       style: Theme.of(context).textTheme.display1,
        //     ),
        //   ),
        // ),
        // StickyHeader(
        //   header: BrandsIconsCarouselWidget(
        //       heroTag: 'home_brand_1',
        //       brandsList: _brandsList,
        //       onChanged: (id) {
        //         setState(() {
        //           animationController.reverse().then((f) {
        //             _productsOfBrandList = _brandsList.list.firstWhere((brand) {
        //               return brand.id == id;
        //             }).products;
        //             animationController.forward();
        //           });
        //         });
        //       }),
        //   content: CategorizedProductsWidget(animationOpacity: animationOpacity, productsList: _productsOfBrandList),
        // ),
      ],
    );
//      ],
//    );
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
          onPressed: () {}),
    );
  }
}
