<<<<<<< HEAD
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with TickerProviderStateMixin {
  AnimationController _resizableController;
  Animation _animation;

  AnimatedBuilder getContainer() {
    return new AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(24),
            child: Text("SAMPLE"),
            decoration: BoxDecoration(
              color: appColors.Colors().mainColor(1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                  color: appColors.Colors().mainColor(1),
                  width: _animation.value * 10),
            ),
          );
        });
  }

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 800,
      ),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_resizableController);
    _resizableController.addStatusListener((animationStatus) {
      //print(_resizableController.value);
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _animation.addListener(() {
      print(_animation.value);
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Test"),
            centerTitle: true,
          ),
          body: Center(child: getContainer())),
    );
  }
}
=======
import 'package:ecommerce_app_ui_kit/config/app_config.dart' as appColors;
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with TickerProviderStateMixin {
  AnimationController _resizableController;
  Animation _animation;

  AnimatedBuilder getContainer() {
    return new AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(24),
            child: Text("SAMPLE"),
            decoration: BoxDecoration(
              color: appColors.Colors().mainColor(1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                  color: appColors.Colors().mainColor(1),
                  width: _animation.value * 10),
            ),
          );
        });
  }

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 800,
      ),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_resizableController);
    _resizableController.addStatusListener((animationStatus) {
      //print(_resizableController.value);
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _animation.addListener(() {
      print(_animation.value);
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Test"),
            centerTitle: true,
          ),
          body: Center(child: getContainer())),
    );
  }
}
>>>>>>> 9a0e1febc8dad89bb8cfb36a94c1515ac88be72d
