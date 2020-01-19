import 'dart:async';

import 'package:done_app/Screen/login_screen/LoginScreen.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  double width, height;
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      _controller,
    );

    _controller.addListener(() {
      setState(() {});
    });
    _animation.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/loginScreen');
        /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);*/
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Opacity(
      opacity: _animation.value,
      child: Container(
        width: width,
        height: height,
        child: Center(
          child: Image.asset(
            "assets/images/done_logo.png",
            width: 200.0,
            height: 100.0,
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Tags.colorPrimary,Tags.colorEndGradient],begin: Alignment.topCenter,end: Alignment.bottomCenter,stops: [.3,.9])
        ),
      ),
    );
  }
}
