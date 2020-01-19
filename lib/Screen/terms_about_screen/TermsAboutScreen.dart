import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class TermsAboutScreen extends StatefulWidget {
  final int _type;

  TermsAboutScreen(this._type);

  @override
  _TermsAboutScreenState createState() => _TermsAboutScreenState(_type);
}

class _TermsAboutScreenState extends State<TermsAboutScreen> {
  int _type;

  _TermsAboutScreenState(this._type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Tags.colorPrimary,
        title: Text(
          _type == 1 ? 'Terms and conditions' : 'About',
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10.0),
            child: Text(
              "",
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
          Center(
            child: Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Tags.colorPrimary),
                )),
          )
        ],
      ),
    );
  }
}
