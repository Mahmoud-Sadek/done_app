import 'package:done_app/tags/Tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PasswordDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PasswordDialogState();
}


class PasswordDialogState extends State<PasswordDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  SharedPreferences prefs;


  TextEditingController passwordController= new TextEditingController();
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 240.0,

              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.fingerprint,
                    color: Tags.colorPrimary,
                    size: 30,
                  ),
                  Form(
                    child: TextFormField(
                      controller: passwordController,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0, color: Tags.colorPrimary),
                      // ignore: missing_return
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Field required";
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Password",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Tags.colorPrimary)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Tags.colorPrimary)),
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            color: Tags.colorPrimary,
                          )),
                    ),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ButtonTheme(
                                height: 35.0,
                                minWidth: 110.0,
                                child: RaisedButton(
                                  color: Tags.colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Tags.colorPrimary.withAlpha(40),
                                  child: Text('Save',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                  onPressed: () async {

                                    await _editPassword();
                                    Navigator.of(context).pop();
                                  },
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                              child:  ButtonTheme(
                                  height: 35.0,
                                  minWidth: 110.0,
                                  child: RaisedButton(
                                    color: Tags.colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0)),
                                    splashColor: Tags.colorPrimary.withAlpha(40),
                                    child: Text('Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ))
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
  _editPassword() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setString('password', passwordController.text);
  }
}
