import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:done_app/Screen/add_date_screen/password_dialog.dart';
import 'package:done_app/models/alarm_body.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:done_app/utils/database.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_record/flutter_record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PermissionState {
  granted,
  denied,
  disabled,
  restricted,
  unknown,
  neverAskAgain
}

class AddDateScreen extends StatefulWidget {
  @override
  _AddDateScreenState createState() => _AddDateScreenState();
}

class _AddDateScreenState extends State<AddDateScreen> {
  FlutterRecord _flutterRecord;
  String _date = "", _time = "", _privacy="";
  DateTime _dateTimeDate, _dateTimeTime;
  String recordState = "";
  String _recordPath = "";
  Uint8List _bytes;

  DBHelper dbHelper;

  TextEditingController messageEditingController = TextEditingController();
  Future<List<AlarmBody>> products;

  @override
  void initState() {
    super.initState();
    _flutterRecord = FlutterRecord();
    //_checkAudioPermission();
    dbHelper = DBHelper();
    refreshDatabaseist();
  }

  refreshDatabaseist() {
    setState(() {
      products = dbHelper.getproducts();
    });
  }

  Future<void> _checkMicPermission() async {
    _startRecord();
  }

  void _startRecord() async {
    try {
      _recordPath = await _flutterRecord.startRecorder(
          path: "done_app_record", maxVolume: 1.0);
      print("path $_recordPath");
    } on PlatformException {}
  }

  void _stopRecord() async {
    await _flutterRecord.stopRecorder().then((value) {
      _flutterRecord.setVolume(1.0);
      _flutterRecord.startPlayer(path: _recordPath);
    });
  }

  Future<void> _shareAudio() async {
    if (_recordPath != "Recorder is already recording.") {
      _bytes = await File(_recordPath).readAsBytes();
      await Share.file("Share sound", "record.aac", _bytes, "*/*", text: "");
    } else {
      _createAlertDialog("Please record a voice");
    }
  }

  void _displayDateCalender() {
    DateTime _now = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: _now,
            firstDate: _now,
            lastDate: DateTime(_now.year + 100))
        .then((date) {
      setState(() {
        _date = DateFormat("dd/MMM/yyyy").format(date);
        _dateTimeDate = date;
      });
    });
  }

  void _displayTimeCalender() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
      setState(() {
        DateTime now = DateTime.now();
        DateTime dateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        _time = DateFormat("hh:mm aa").format(dateTime);
        _dateTimeTime = dateTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.05 * width),
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Tags.colorPrimary, Tags.colorEndGradient],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [.3, .9])),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26.0,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Add Alarm",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: width,
              height: 5.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
            ),
            SizedBox(
              height: 30.0,
            ),
            _getTimeRow(_displayTimeCalender),
            SizedBox(
              height: 30,
            ),
            _getDateRow(_displayDateCalender),
            SizedBox(
              height: 30.0,
            ),
            Container(
              child: Text(
                "Details :",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              cursorColor: Colors.white,
              controller: messageEditingController,
              maxLines: 5,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _checkMicPermission();

                  setState(() {
                    recordState = "Recording...";
                  });
                },
                onTapUp: (TapUpDetails details) {
                  _stopRecord();
                  setState(() {
                    recordState = "";
                  });

                  print("finished");
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white)),
                  child: CircleAvatar(
                    backgroundColor: Tags.secondColor,
                    child: Image.asset(
                      "assets/images/microphone.png",
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    radius: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                recordState,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            RadioButtonGroup(labels: <String>[
              "Public",
              "Personal",
            ],
                labelStyle: TextStyle(color: Colors.white),orientation: GroupedButtonsOrientation.VERTICAL,onSelected: (String selected) {
              _privacy=selected;
              print(selected);
            }),
            SizedBox(
              height: 0.0,
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    onPressed: () async {
                      addAlarm();
                      /*final int helloAlarmID = 0;
                      await AndroidAlarmManager.initialize();

                      await AndroidAlarmManager.periodic(const Duration(seconds: 10), helloAlarmID, printHello);
                      await AndroidAlarmManager.periodic(
                          const Duration(seconds: 5), 0, printPeriodic,
                          wakeup: true, exact: true);
                      await AndroidAlarmManager.oneShot(
                          const Duration(seconds: 5), 1, printOneShot);
                      printHello();*/
                    },
                    color: Tags.secondColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        side: BorderSide(color: Colors.white)),
                    child: Text(
                      'Save for me',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: RaisedButton(
                    onPressed: () {
                      _shareAudio();
                    },
                    color: Tags.colorGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        side: BorderSide(color: Colors.white)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Save & Share',
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        Icon(
                          Icons.reply,
                          color: Colors.white,
                          size: 25,
                        )
                      ],
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getTimeRow(Function function) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "TIME :",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Choose time",
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 26.0,
                    )
                  ],
                ),
                onTap: () {
                  function();
                },
              ),
              Text(
                _time ?? '',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getDateRow(Function function) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Date :",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Choose date",
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 26.0,
                    )
                  ],
                ),
                onTap: () {
                  function();
                },
              ),
              Text(
                _date ?? '',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
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

  void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
    _createAlertDialog("sadek");
  }

  void printPeriodic() => print("Periodic!");

  void printOneShot() => print("One shot!");

  Future<void> addAlarm() async {



    if (!validate()) return;
    if (_recordPath != "Recorder is already recording.") {
      _bytes = await File(_recordPath).readAsBytes();
    } else {

      Fluttertoast.showToast(
          msg: "Please record a voice",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if(_privacy=="Personal"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(!prefs.containsKey('password'))
        showDialog(
          context: context,
          builder: (_) => PasswordDialog(),
        ).then((val) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey('password'))
            addToDatabase();
        });
      else addToDatabase();
    }else{

        addToDatabase();
    }

  }

  bool validate()  {
    String message = '';
    if (_date.isEmpty)
      message = "Enter Date !!";
    else if (_time.isEmpty)
      message = "Enter Time !!";
    else if (messageEditingController.text.isEmpty)
      message = "Enter Description !!";
    else if (_recordPath.isEmpty) message = "Add Recoded !!";
    else if (_privacy.isEmpty) message = "Select Privacy !!";

    if (message.isEmpty) return true;


    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }

  void addToDatabase() {
    AlarmBody body = new AlarmBody();
    body.time = _time;
    body.date = _date;
    body.description = messageEditingController.text;
    body.file_url = _bytes;
    body.privacy = _privacy;

    dbHelper.add(body);
    Navigator.pop(context);
  }
}
