import 'package:flutter/material.dart';

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('img/img.png'), fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 30),
          Text("These are empty, would look beautiful with picutres of your's", style: TextStyle(fontSize: 13, letterSpacing: 1.2),)
        ]),
      ),
    );
  }
}
