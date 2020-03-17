import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/Model/currentuser.dart';
import 'package:ecommerce_app_ui_kit/Model/matchrequestmodel.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/src/models/product.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
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

  @override
  void initState() {
    _productsList = new ProductsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<CurrentUserInfo>(context);
    final pr = loadingBar(context, "Fetching data");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon:
              new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
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
                child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height*0.45,
                          //width: MediaQuery.of(context).size.height*0.4,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/astro.png'),fit: BoxFit.fill)),),
                        SizedBox(height: 30,),
                        Text("You're Alone Here !!",style: TextStyle(fontSize: 13),),
                      ],
                    ),
              );
            } else {
              print(items);
              pr.dismiss();
              return Container(
                margin: EdgeInsetsDirectional.only(top: 2),
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      // margin: EdgeInsets.only(top:6,left:6,right:6,bottom:25),
                      // padding: EdgeInsets.all(10.0),
                      height: ScreenSizeConfig.safeBlockVertical * 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                            // color: Colors.blue,
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              // color: Colors.white70,
                              blurRadius: 10.0,
                              spreadRadius: 3.0,
                              offset: Offset(5, 5))
                        ],
                      ),
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
                                .acceptReq(item.uid, item.name, info.name)
                                .then((onValue) {
                              setState(() {
                                items.removeAt(index);
                                print("-------------------------requesteduser----------------");
                                print(item.name);
                                print("------------------------currentuser-----------------------");
                                print(info.name);
                              });
                            });
                          } else {
                            setState(() {
                              items.removeAt(index);
                            });
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              // margin: EdgeInsets.all(8),
                              // padding: EdgeInsets.all(9.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white70,
                                      blurRadius: 10.0,
                                      spreadRadius: 3.0,
                                      offset: Offset(5, 5))
                                ],
                              ),
                              height: ScreenSizeConfig.blockSizeVertical * 18,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  (item.avatar != "" && item.avatar != null)
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(item.avatar),
                                          radius: ScreenSizeConfig
                                                  .safeBlockVertical *
                                              6,
                                        )
                                      : CircleAvatar(
                                          // backgroundImage: NetworkImage(item.avatar),
                                          radius: ScreenSizeConfig
                                                  .safeBlockVertical *
                                              6,
                                        ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              item.name
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700))
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Text("Time : ${item.time}"),
                                      SizedBox(width: 10),
                                      Text("uid : ${item.uid}")
                                      // FlatButton.icon(
                                      //     onPressed: () {
                                      //       setState(() {
                                      //         items.removeAt(index);
                                      //       });
                                      //     },
                                      //     icon: Icon(
                                      //       Icons.arrow_right,
                                      //       color: Colors.green,
                                      //     ),
                                      //     label: Text("ACCEPT",
                                      //         style: TextStyle(
                                      //             color: Colors.green))),
                                      // FlatButton.icon(
                                      //     onPressed: null,
                                      //     icon: Icon(
                                      //       Icons.arrow_left,
                                      //       color: config.Colors().mainColor(1),
                                      //     ),
                                      //     label: Text("REJECT",
                                      //         style: TextStyle(
                                      //             color: config.Colors()
                                      //                 .mainColor(1))))
                                    ],
                                  )
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
