import 'package:ecommerce_app_ui_kit/Helper/loading.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
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
            } else {
              print(items);
              pr.dismiss();
              return Container(
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: dismissableKey,
                      confirmDismiss: (direction) {
                        // RangeSlider(values: null, onChanged: null)
                        if (direction == DismissDirection.startToEnd) {
                          DatabaseService().acceptReq(item.uid).then((onValue) {
                            if (onValue) {
                              return Future.value(true);
                            } else {
                              return Future.value(false);
                            }
                          });
                        }
                        return Future.value(false);
                      },
                      background: Container(
                        color: Colors.green,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          print("CONFIRM");
                          items.removeAt(index);
                        } else {
                          //  items.removeAt(index);
                          print("REJECT");
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: ScreenSizeConfig.blockSizeVertical * 15,
                          child: Row(
                            children: <Widget>[
                              (item.avatar != "" && item.avatar != null)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(item.avatar),
                                      radius:
                                          ScreenSizeConfig.safeBlockVertical *
                                              6,
                                    )
                                  : CircleAvatar(
                                      // backgroundImage: NetworkImage(item.avatar),
                                      radius:
                                          ScreenSizeConfig.safeBlockVertical *
                                              6,
                                    ),
                              Column(
                                children: <Widget>[
                                  Text(item.name.toString().toUpperCase()),
                                  Row(
                                    children: <Widget>[
                                      FlatButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              items.removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.arrow_right,
                                            color: Colors.green,
                                          ),
                                          label: Text("ACCEPT",
                                              style: TextStyle(
                                                  color: Colors.green))),
                                      FlatButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.arrow_left,
                                            color: config.Colors().mainColor(1),
                                          ),
                                          label: Text("REJECT",
                                              style: TextStyle(
                                                  color: config.Colors()
                                                      .mainColor(1))))
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
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
