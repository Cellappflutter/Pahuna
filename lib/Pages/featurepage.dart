import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/Data.dart';
import 'package:ecommerce_app_ui_kit/Pages/book.dart';
import 'package:ecommerce_app_ui_kit/Pages/categories_tabs.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double notexpanded = MediaQuery.of(context).size.height * 0.39;
    double expanded = MediaQuery.of(context).size.height * 0.2;

    return SafeArea(
          child: Scaffold(
        appBar: customAppBar(context, widget.featureData.title),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.redAccent, Colors.blueAccent])),
            child: Stack(
              children: <Widget>[
                ImagesSlider(image: widget.featureData.image,),
                BottomView(
                  featuredata: widget.featureData,
                  expanded: expanded,
                  notexpanded: notexpanded,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child:
                          // AlertDialog(
                          //   shape: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(16.0)),
                          //   title: Text('Hello!!'),
                          //   content: Text('How are you?'),
                          // ),
                          Book(),
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
          },
          child: Icon(Icons.book),
        ),
      ),
    );
  }
}

class BottomView extends StatefulWidget {
  final double expanded, notexpanded;
  final Featuredata featuredata;
  BottomView({
    Key key,
    this.expanded,
    this.notexpanded,
    this.featuredata,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _bottomview();
  }
}

class _bottomview extends State<BottomView> with TickerProviderStateMixin {
  bool isexpanded = false;
  AnimationController animationController;
  Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: widget.notexpanded, end: widget.expanded)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut,reverseCurve: Curves.easeIn))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Positioned(
        top: animation.value,
        child: GestureDetector(
          onTap: () {
            setState(() {
              animationController.isCompleted
                  ? animationController.reverse()
                  : animationController.forward();
            });
          },
         onVerticalDragEnd: (DragEndDetails draged){
           if(draged.primaryVelocity<0.0){
             animationController.forward();
           }else if(draged.primaryVelocity >0.0){
             animationController.reverse();

           }else{
             return;
           }
         },
         onVerticalDragDown: (detail){
           setState(() {
             animationController.reverse();
           });
         },
        //  onVerticalDragStart: (detail){
        //    setState(() {
        //      animationController.forward();
        //    });
        //  },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 5,
                    width: 100,
                    color: Colors.redAccent,
                  ),
                ),
                DefaultTabController(
                    length: 2,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          TabBar(tabs: [
                            Tab(text: 'Description'),
                            Tab(
                              text: 'Reviews',
                            )
                          ]),
                          Container(
                            height: MediaQuery.of(context).size.height*0.7,
                            width: MediaQuery.of(context).size.width,
                            child: TabBarView(children: [
                              Details_Tab(details: widget.featuredata.content),
                              Review_tab()
                            ]),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}

class ImagesSlider extends StatefulWidget {
 final String image;

   ImagesSlider({Key key, @required this.image}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImagesSlider();
  }
}

class _ImagesSlider extends State<ImagesSlider> {
  
  List<String> images = [
    'https://c4.wallpaperflare.com/wallpaper/760/955/638/artwork-landscape-sky-mountains-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/500/442/354/outrun-vaporwave-hd-wallpaper-thumb.jpg',
    'https://c4.wallpaperflare.com/wallpaper/262/774/423/space-stars-nebula-tylercreatesworlds-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/246/739/689/digital-digital-art-artwork-illustration-abstract-hd-wallpaper-preview.jpg'
  ];
  

  @override
  Widget build(BuildContext context) {
    images.add(widget.image);
    // TODO: implement build
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (BuildContext context, index) {
              return Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                      image: NetworkImage(images[index]), fit: BoxFit.fill),
                ),
              );
            },
            options: CarouselOptions(
              initialPage: 2,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1.4,
                viewportFraction: 0.8,
                autoPlayCurve: Curves.easeInOutQuint)));
  }
}

// class _FeaturePageState extends State<FeaturePage> {
//   int indexWidget = 0;
//   Widget currentWidget;

//   @override
//   Widget build(BuildContext context) {
//     ScreenSizeConfig().init(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: 800,
//           child: Stack(
//             children: <Widget>[
//               CustomScrollView(
//                 slivers: <Widget>[
//                   SliverAppBar(
//                     backgroundColor: Color(0xFF2C2C2C),
//                     forceElevated: true,
//                     elevation: 10,
//                     centerTitle: true,
//                     expandedHeight: ScreenSizeConfig.safeBlockVertical * 40,
//                     pinned: true,
//                     stretch: true,
//                     floating: false,
//                     leading: InkWell(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Icon(
//                         UiIcons.return_icon,
//                         color: Colors.white,
//                       ),
//                     ),
//                     flexibleSpace: Stack(
//                       children: <Widget>[
//                         FlexibleSpaceBar(
//                           background: topImage(context),
//                           collapseMode: CollapseMode.parallax,
//                           title: Text(
//                             widget.featureData.title,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SliverStickyHeader(
//                     header: Container(
//                       //  height: 60.0,
//                       color: Colors.white.withOpacity(0.8),
//                       padding: EdgeInsets.symmetric(horizontal: 16.0),
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           RaisedButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0)
//                             ),
//                             color: Color(0xffdd2827),
//                             highlightColor: Colors.yellow,
//                             onPressed: () {
//                               setState(() {
//                                 indexWidget = 0;
//                               });
//                             },
//                             child: Text(
//                               "Medias",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           RaisedButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0)
//                             ),
//                             color: Color(0xffdd2827),
//                             onPressed: () {
//                               setState(() {
//                                 indexWidget = 1;
//                               });
//                             },
//                             child: Text(
//                               "Information",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           RaisedButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius:BorderRadius.circular(8.0)
//                             ),
//                             color: Color(0xffdd2827),
//                             onPressed: () {
//                               setState(() {
//                                 indexWidget = 2;
//                               });
//                             },
//                             child: Text(
//                               "Reviews",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     sliver: getSliverWidgets(),
//                   ),
//                 ],
//               ),
//               Align(
//                   alignment: Alignment.bottomRight,
//                   child: FloatingActionButton.extended(
//                     elevation: 3,
//                     backgroundColor: Colors.blueAccent,
//                     label: Text(
//                       "Book Now",
//                       style: TextStyle(letterSpacing: 3.3),
//                     ),
//                     onPressed: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => Book()));
//                     },
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   featuresChip(String title, void onTap()) {
//     return Container(
//       margin: EdgeInsets.only(left: appColors.App(context).appHeight(3)),
//       child: RaisedButton(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: Text(
//             title,
//             style: TextStyle(color: Colors.white),
//           ),
//           color: appColors.Colors().mainColor(1),
//           // splashColor: appColors.Colors().mainColor(1),
//           onPressed: () {
//             onTap();
//           }),
//     );
//   }

//   Widget topImage(BuildContext context) {
//     return Container(
//       // height: ScreenSizeConfig.safeBlockVertical * 30,
//       //width: MediaQuery.of(context).size.width,
//       child: Stack(
//         fit: StackFit.expand,
//         overflow: Overflow.visible,
//         children: <Widget>[
//           (widget.featureData.image != null && widget.featureData.image != "")
//               ? Image(
//                   image: CachedNetworkImageProvider(widget.featureData.image),
//                   fit: BoxFit.fill,
//                 )
//               // Image.network(
//               //     widget.featureData.image,
//               //     fit: BoxFit.fill,
//               //   )
//               : Image.asset(
//                   "assets/user3.jpg",
//                   fit: BoxFit.fill,
//                 ),
//         ],
//       ),
//     );
//   }

//   getSliverWidgets() {
//     switch (indexWidget) {
//       case 0:
//         {
//           return (Medias_Tab());
//         }
//       case 1:
//         {
// return Details_Tab(
//    details: widget.featureData.content,
//  );
//         }
//       case 2:
//         {
//           return (Review_tab());
//         }
//       default:
//         {
//           return Medias_Tab();
//         }
//     }
//   }
// }
