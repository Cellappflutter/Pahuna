import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';

import 'UiHelper/loading.dart';


class Search_BottomSheet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _searchsheet();
      }
    }
    
    class _searchsheet extends State<Search_BottomSheet>{
      @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10)
                      ]),
                      margin: EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: CircleAvatar(),
                            ),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.green,
                              child: Column(
                                children: <Widget>[
                                 // Text(info[i].uid),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text('Send Request'),
                                          onPressed: () {
                                            final pr = loadingBar(
                                                context, "Sending Request");
                                            pr.show();
                                            DatabaseService()
                                                .sendReq(null)//info[i].uid)
                                                .then((onValue) {
                                              pr.dismiss();
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10.0),
                                        RaisedButton(
                                          child: Text('Follow'),
                                          onPressed: () {},
                                        )
                                      ]),
                                ],
                              ),
                            ),
                            Container(
                              height: 200,
                              color: Colors.blue,
                            ),
                            Container(
                              height: 200,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ),
                    );;
  }
}