import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class PagePublic extends StatefulWidget {
  @override
  _PagePublicState createState() => _PagePublicState();
}

class _PagePublicState extends State<PagePublic> {
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
