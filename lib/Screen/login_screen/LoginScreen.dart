import 'dart:async';

import 'package:done_app/Screen/home_screen/HomeScreen.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double width, height;
  String _phoneCode, _phone;
  int _counter = 120;
  String time = "02:00";
  Timer _timer;
  var _formKey = GlobalKey<FormState>();
  var _formKeyConfirmCode = GlobalKey<FormState>();
  String _verificationId;
  bool _isCodeSent = false, canResendCode = false;
  String _smsCode;

  @override
  void dispose() {
    super.dispose();
    print("disposed");
    if (_timer != null) {
      _timer.cancel();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    //Locale _locale =  Localizations.localeOf(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Tags.colorPrimary, Tags.colorEndGradient],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [.3, .9])),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: .1 * width, vertical: .1 * height),
              child: _isCodeSent ? _validateSendCodePage() : _sendCodePage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sendCodePage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/done_logo.png',
          width: 220.0,
          height: 110.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: CountryCodePicker(
                  onInit: (countryCode) {
                    this._phoneCode = countryCode.dialCode;
                  },
                  showOnlyCountryWhenClosed: false,
                  alignLeft: true,
                  initialSelection: "SA",
                  textStyle: TextStyle(color: Colors.white),
                  onChanged: (CountryCode countryCode) {
                    _phoneCode = countryCode.dialCode;
                    print("code ${countryCode.dialCode}");
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onChanged: (input) {
                      this._phone = input;
                    },
                    // ignore: missing_return
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Field required";
                      }
                    },
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: "Phone number",
                      labelStyle:
                          TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        RaisedButton(
          elevation: 5.0,
          color: Tags.secondColor,
          child: Text(
            'Send code',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              FocusScope.of(context).unfocus();
              _sendCode();
            }
          },
        )
      ],
    );
  }

  Widget _validateSendCodePage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/done_logo.png',
          width: 220.0,
          height: 110.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKeyConfirmCode,
              child: TextFormField(
                onChanged: (input) {
                  _smsCode = input;
                },
                maxLines: 1,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
                // ignore: missing_return
                validator: (input) {
                  if (input.isEmpty) {
                    return "Field required";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Confirm code",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            RaisedButton(
              elevation: 5.0,
              color: Tags.secondColor,
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0)),
              onPressed: () {
                if (_formKeyConfirmCode.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  _createAlertDialog("Wait..");
                  _signIn();
                }
              },
            )
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (canResendCode) {
                      _sendCode();
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/chat_message.png",
                        width: 20.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 5.0),
                          child: Text(
                            "Resend",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ))
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 13.0, color: Colors.white),
                )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: width,
              height: 1.0,
              color: Colors.white,
            )
          ],
        )
      ],
    );
  }

  Future<void> _sendCode() async {
    _createProgressDialog();

    PhoneVerificationCompleted _phoneVerificationComplete =
        (AuthCredential authCredential) {
      setState(() {
        _signInWithCredential(authCredential);
      });
    };

    PhoneVerificationFailed _phoneVerificationFailed = (AuthException e) {
      Navigator.of(context).pop();

      if (e.message != null) {
        _createAlertDialog(e.message);
      } else {
        _createAlertDialog("Failed something haywire.");
      }
    };

    PhoneCodeSent _phoneCodeSent =
        (String verificationId, [int forceResendingToken]) {
      Navigator.of(context).pop();

      _verificationId = verificationId;
      _startTimer();
      setState(() {
        print("on code send");
        _isCodeSent = !_isCodeSent;
      });
    };

    PhoneCodeAutoRetrievalTimeout _autoRetrievalTimeout =
        (String verificationId) {
          Navigator.of(context).pop();

          _verificationId = verificationId;
    };

    String phone = "$_phoneCode$_phone";
    print("phone $phone");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 2),
      verificationCompleted: _phoneVerificationComplete,
      verificationFailed: _phoneVerificationFailed,
      codeSent: _phoneCodeSent,
      codeAutoRetrievalTimeout: _autoRetrievalTimeout,
    );
  }

  Future<void> _signIn() async {

    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsCode);
    FirebaseAuth.instance.signInWithCredential(authCredential).then((result) {
      _deleteUser(result);
    }, onError: (error) {
      Navigator.of(context).pop();

      if (error != null) {
        _createAlertDialog(error.toString());
      } else {
        _createAlertDialog("Failed something haywire.");
      }
      print('error  $error');
    });
  }

  Future<void> _signInWithCredential(AuthCredential authCredential) async {
    FirebaseAuth.instance.signInWithCredential(authCredential).then((result) {
      _deleteUser(result);
    }, onError: (error) {
      Navigator.of(context).pop();

      if (error != null) {
        _createAlertDialog(error);
      } else {
        _createAlertDialog("Failed something haywire.");
      }
      print('error  $error');
    });
  }

  Future<void> _deleteUser(AuthResult result) async {
    Navigator.of(context).pop();
    await result.user.delete().whenComplete(() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_counter >= 0) {
        setState(() {
          canResendCode = false;

          int minutes = ((_counter % 3600) ~/ 60).toInt();
          var seconds = (_counter % 60);

          time =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

          _counter -= 1;
        });
      } else {
        canResendCode = true;
        _counter = 120;
        timer.cancel();
      }
    });
  }

  Future<void> _createAlertDialog(String message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(fontSize: 18.0, color: Tags.colorPrimary),
            ),
            content: Text(
              message,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 15.0, color: Tags.colorPrimary),
                ),
              )
            ],
          );
        });
  }

  Future<void> _createProgressDialog() async {
    await showDialog(

      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 8.0,
            content: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  valueColor: new AlwaysStoppedAnimation<Color>(Tags.colorPrimary),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Wait...",
                  style: TextStyle(
                      color: Color(0xffcdcdcd),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        });
  }
}
