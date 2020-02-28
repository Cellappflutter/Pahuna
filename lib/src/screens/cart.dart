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
          //    pr.show();
              return Container(color: Colors.green);
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
                    // if (direction == DismissDirection.startToEnd) {
                    //   DatabaseService().acceptReq(item.uid).then((onValue) {
                    //     if (onValue) {
                    //       //print("accept");
                    //       return Future.value(true);
                    //     } else {
                    //       return Future.value(false);
                    //     }
                    //   });
                    
                    //}
                    return Future.value(true);
                  },
                  background: Container(
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[Text("ACCEPT")],
                      )),
                  secondaryBackground: Container(
                    color: Color(0xFFE15244),
                    child: Column(
                      children: <Widget>[Text("REJECT"),],
                    ),
                  ),
                  onDismissed: (direction) {
                    print(direction.index);
                    if (direction == DismissDirection.startToEnd) {
                      print("CONFIRM");
                      //items.removeAt(index);
                    } else {
                    //  items.removeAt(index);
                      print("REJECT");
                    }
                  },
                  child: Card(
                    elevation: 0,
                    color: pressed,
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: ScreenSizeConfig.blockSizeVertical * 15,
                        child: Row(
                          children: <Widget>[
                            (item.avatar != ""&&item.avatar!=null)
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(item.avatar),
                                    radius:
                                        ScreenSizeConfig.safeBlockVertical * 6,
                                  )
                                : CircleAvatar(
                                    // backgroundImage: NetworkImage(item.avatar),
                                    radius:
                                        ScreenSizeConfig.safeBlockVertical * 6,
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
                                        icon: Icon(Icons.arrow_right, color: Colors.green,),
                                        label: Text("ACCEPT",style: TextStyle(color:Colors.green))),
                                    FlatButton.icon(
                                        onPressed: null,
                                        icon: Icon(Icons.arrow_left, color: config.Colors().mainColor(1),),
                                        label: Text("REJECT",style:TextStyle(color: config.Colors().mainColor(1)) ))
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                );
              },
            ),
          );
              // return Stack(
              //   fit: StackFit.expand,
              //   children: <Widget>[
              //     Container(
              //       margin: EdgeInsets.only(bottom: 150),
              //       padding: EdgeInsets.only(bottom: 15),
              //       child: SingleChildScrollView(
              //         padding: EdgeInsets.symmetric(vertical: 10),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.max,
              //           children: <Widget>[
              //             // Padding(
              //             //   padding: const EdgeInsets.only(left: 20, right: 10),
              //             //   child: ListTile(
              //             //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //             //     leading: Icon(
              //             //       UiIcons.shopping_cart,
              //             //       color: Theme.of(context).hintColor,
              //             //     ),
              //             //     title: Text(
              //             //       'Shopping Cart',
              //             //       maxLines: 1,
              //             //       overflow: TextOverflow.ellipsis,
              //             //       style: Theme.of(context).textTheme.display1,
              //             //     ),
              //             //     subtitle: Text(
              //             //       'Verify your quantity and click checkout',
              //             //       maxLines: 1,
              //             //       overflow: TextOverflow.ellipsis,
              //             //       style: Theme.of(context).textTheme.caption,
              //             //     ),
              //             //   ),
              //             // ),
              //             ListView.separated(
              //               padding: EdgeInsets.symmetric(vertical: 15),
              //               scrollDirection: Axis.vertical,
              //               shrinkWrap: true,
              //               primary: false,
              //               itemCount: _productsList.cartList.length,
              //               separatorBuilder: (context, index) {
              //                 return SizedBox(height: 15);
              //               },
              //               itemBuilder: (context, index) {
              //                 return CartItemWidget(
              //                     product:
              //                         _productsList.cartList.elementAt(index),
              //                     heroTag: 'cart');
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     // Positioned(
              //     //   bottom: 0,
              //     //   child: Container(
              //     //     height: 170,
              //     //     padding:
              //     //         EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //     //     decoration: BoxDecoration(
              //     //         color: Theme.of(context).primaryColor,
              //     //         borderRadius: BorderRadius.only(
              //     //             topRight: Radius.circular(20),
              //     //             topLeft: Radius.circular(20)),
              //     //         boxShadow: [
              //     //           BoxShadow(
              //     //               color: Theme.of(context)
              //     //                   .focusColor
              //     //                   .withOpacity(0.15),
              //     //               offset: Offset(0, -2),
              //     //               blurRadius: 5.0)
              //     //         ]),
              //     //     child: SizedBox(
              //     //       width: MediaQuery.of(context).size.width - 40,
              //     //       child: Column(
              //     //         crossAxisAlignment: CrossAxisAlignment.center,
              //     //         mainAxisSize: MainAxisSize.max,
              //     //         children: <Widget>[
              //     //           Row(
              //     //             children: <Widget>[
              //     //               Expanded(
              //     //                 child: Text(
              //     //                   'Subtotal',
              //     //                   style: Theme.of(context).textTheme.body2,
              //     //                 ),
              //     //               ),
              //     //               Text('\$50.23',
              //     //                   style: Theme.of(context).textTheme.subhead),
              //     //             ],
              //     //           ),
              //     //           SizedBox(height: 5),
              //     //           Row(
              //     //             children: <Widget>[
              //     //               Expanded(
              //     //                 child: Text(
              //     //                   'TAX (20%)',
              //     //                   style: Theme.of(context).textTheme.body2,
              //     //                 ),
              //     //               ),
              //     //               Text('\$13.23',
              //     //                   style: Theme.of(context).textTheme.subhead),
              //     //             ],
              //     //           ),
              //     //           SizedBox(height: 10),
              //     //           Stack(
              //     //             fit: StackFit.loose,
              //     //             alignment: AlignmentDirectional.centerEnd,
              //     //             children: <Widget>[
              //     //               SizedBox(
              //     //                 width: MediaQuery.of(context).size.width - 40,
              //     //                 child: FlatButton(
              //     //                   onPressed: () {
              //     //                     Navigator.of(context)
              //     //                         .pushNamed('/Checkout');
              //     //                   },
              //     //                   padding: EdgeInsets.symmetric(vertical: 14),
              //     //                   color: Theme.of(context).accentColor,
              //     //                   shape: StadiumBorder(),
              //     //                   child: Text(
              //     //                     'Checkout',
              //     //                     textAlign: TextAlign.start,
              //     //                     style: TextStyle(
              //     //                         color:
              //     //                             Theme.of(context).primaryColor),
              //     //                   ),
              //     //                 ),
              //     //               ),
              //     //               Padding(
              //     //                 padding: const EdgeInsets.symmetric(
              //     //                     horizontal: 20),
              //     //                 child: Text(
              //     //                   '\$55.36',
              //     //                   style: Theme.of(context)
              //     //                       .textTheme
              //     //                       .display1
              //     //                       .merge(TextStyle(
              //     //                           color: Theme.of(context)
              //     //                               .primaryColor)),
              //     //                 ),
              //     //               )
              //     //             ],
              //     //           ),
              //     //           SizedBox(height: 10),
              //     //         ],
              //     //       ),
              //     //     ),
              //     //   ),
              //     // )
              //   ],
              // );
            }
          },
        ),
      ),
    );
  }
}
