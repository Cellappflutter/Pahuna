import 'package:flutter/material.dart';
import 'package:ecommerce_app_ui_kit/Model/userdata.dart';

class OnlineUserUI extends StatefulWidget {
  final UserData info;
  OnlineUserUI({this.info});
  @override
  _OnlineUserUIState createState() => _OnlineUserUIState();
}

class _OnlineUserUIState extends State<OnlineUserUI> {
  static double _minHeight = 100, _maxHeight = 600;
  Offset _offset = Offset(0, _minHeight);
//  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
   // print(status);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Align(
          //   alignment: Alignment.topLeft,
          //   // child: FlatButton(
          //   //   onPressed: _handleClick,
          //   //   splashColor: Colors.transparent,
          //   //   textColor: Colors.grey,
          //   //   child: Text(_isOpen ? "Back" : ""),
          //   // ),
          // ),
          Align(child: Container()),
          GestureDetector(
            onPanUpdate: (details) {
              _offset = Offset(0, _offset.dy - details.delta.dy);
              if (_offset.dy < _minHeight) {
                _offset = Offset(0, _minHeight);
                //   _isOpen = false;
              } else if (_offset.dy > _maxHeight) {
                _offset = Offset(0, _maxHeight);
                // _isOpen = true;
              }
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration.zero,
              curve: Curves.easeOut,
              height: _offset.dy,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10)
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(widget.info.uid),
                    Text(widget.info.longitude.toString()),
                    Container(height: 300, color: Colors.red),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Align(
      //     alignment: Alignment.centerLeft,
      //     child: GestureDetector(
      //       onPanUpdate: (details) {
      //         print(details.delta.dy);
      //         _offset = Offset(0, _offset.dy - details.delta.dy);
      //         if (_offset.dy < _minHeight) {
      //           _offset = Offset(0, _minHeight);
      //           //_isOpen = false;
      //         } else if (_offset.dy > _maxHeight) {
      //           _offset = Offset(0, _maxHeight);
      //           //   _isOpen = true;
      //         }
      //         setState(() {});
      //       },
      //       child: AnimatedContainer(
      //         duration: Duration.zero,
      //         curve: Curves.easeOut,
      //         height: _offset.dy,
      //         alignment: Alignment.bottomCenter,
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(30),
      //               topRight: Radius.circular(30),
      //             ),
      //             boxShadow: [
      //               BoxShadow(
      //                   color: Colors.red.withOpacity(0.6),
      //                   spreadRadius: 6,
      //                   blurRadius: 200)
      //             ]),
      //         child: Column(
      //           children: <Widget>[
      //             Text(widget.info.uid),
      //             Text(widget.info.longitude.toString()),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
