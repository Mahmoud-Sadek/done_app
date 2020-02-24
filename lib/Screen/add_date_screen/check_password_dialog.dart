import 'package:done_app/tags/Tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckPasswordDialog extends StatefulWidget {
  static bool access=false;
  @override
  State<StatefulWidget> createState() => CheckPasswordDialogState();
}


class CheckPasswordDialogState extends State<CheckPasswordDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  SharedPreferences prefs;


  TextEditingController passwordController= new TextEditingController();

  @override
  void initState() {
    super.initState();
    CheckPasswordDialog.access=false;

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
                  GestureDetector(
                    onTap: () async {
                      await _checkBiometrics();
                      await _getAvailableBiometrics();
                      await _authenticate();
                      Fluttertoast.showToast(
                          msg: _authorized,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      if(!_authorized.toLowerCase().contains('not')) {
                        CheckPasswordDialog.access = true;
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(
                      Icons.fingerprint,
                      color: Tags.colorPrimary,
                      size: 30,
                    ),
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

    if(prefs.getString('password')==passwordController.text)
    CheckPasswordDialog.access=true;
    else
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
  }



  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    }  catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }
}
