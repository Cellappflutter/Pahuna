import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as config;
import 'UiHelper/loading.dart';

class Search_BottomSheet extends StatefulWidget {
  String name, email;
  Search_BottomSheet(this.email, this.name);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _searchsheet();
  }
}

class _searchsheet extends State<Search_BottomSheet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 400,
      child: Column(
        
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    maxRadius: 60,
                    backgroundImage: AssetImage("img/user1.jpg"),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
               // Align(
                //  alignment: Alignment.center,
                 // child: 
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[ Text(widget.name,style: Theme.of(context).textTheme.body2)],
                      ),
                      
                      SizedBox(height: 15,),
                     
                       Row(
                       // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text("Email : ",style: Theme.of(context).textTheme.body2,), Text(widget.email,style:Theme.of(context).textTheme.body1 ,)],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        child: RichText(text: TextSpan(text: "Description : ",style: Theme.of(context).textTheme.body2,children: [TextSpan(
                          text: "This is blah blah basdfjbasdfhue asdjkfkajsd sdhfjkahsdjf jhsdfjasd jshfjasd sdfasdfds asfadsfasdf asdfasd asdfasf asdfasdf adsf adsfadsf ",style: Theme.of(context).textTheme.body1,
                        )]),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton.icon(onPressed: ()=>print("send request"), icon: Icon(Icons.check), label: Text("Send Request")))
                    ],
                  ),
                //)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
