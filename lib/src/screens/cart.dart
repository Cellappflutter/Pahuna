import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/models/product.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  ProductsList _productsList;
  Color pressed = Colors.white;
  Key dismissableKey = Key("Dismiss");
  bool isdismiss = false;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    _productsList = new ProductsList();
    print('this is in requests ');
    databaseService.status();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<CurrentUserInfo>(context);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, "Request"),
        body: StreamProvider.value(
          value: DatabaseService().getMatchRequest(),
          child: Consumer<List<RequestedUser>>(
            builder: (context, items, child) {
              if (items == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (items.length < 1) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('img/astro.png'),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "You're Alone Here !!",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      child: Dismissible(
                        key: dismissableKey,
                        background: Container(
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Color(0xFFE15244),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                UiIcons.trash,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          print(direction.index);
                          if (direction == DismissDirection.startToEnd) {
                            DatabaseService()
                                .acceptReq(item.uid, item.name)
                                .then((onValue) {
                              setState(() {
                                items.removeAt(index);
                              });
                            });
                          } else {
                            setState(() {
                              items.removeAt(index);
                            });
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              (item.avatar != "" && item.avatar != null)
                                  ? Container(
                                      child: CachedNetworkImage(
                                        imageUrl: item.avatar,
                                        height:
                                            ScreenSizeConfig.safeBlockVertical *
                                                13,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Container(
                                      child: Image.asset(
                                        "assets/placeholder.png",
                                        height:
                                            ScreenSizeConfig.safeBlockVertical *
                                                13,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                        item.name.toString().toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Text("Wants to connect with you",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300))
                                ],
                              ),

                              //Text("uid : ${item.uid}")
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
