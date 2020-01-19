import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class PagePerson extends StatefulWidget {
  @override
  _PagePersonState createState() => _PagePersonState();
}

class _PagePersonState extends State<PagePerson> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
       Container(),
        Center(
          child: Container(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Tags.colorPrimary),
              )),
        )
      ],
    );
  }
}
