import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:done_app/routes/Routes.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:done_app/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/splash_screen/SplashScreen.dart';
import 'models/alarm_body.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isInDebugMode = false;


  final int periodicID = 0;
  final int oneShotID = 1;

  WidgetsFlutterBinding.ensureInitialized();

  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();

  printMessage("main run");


  runApp(MyApp());
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 5), periodicID, printPeriodic,
      wakeup: true, exact: true);
  final int  secounds = DateTime.now().difference(DateTime.now().add(Duration(seconds: 10))).inMilliseconds;
  await AndroidAlarmManager.oneShot(
      Duration(seconds: secounds) , oneShotID, printOneShot, alarmClock: true, allowWhileIdle: true, wakeup: true, exact: true);
}

void printPeriodic() async {
  await getAlarmsData();
}

getAlarmsData() async {
  DBHelper dbHelper= DBHelper();
  List<AlarmBody> alarms = await dbHelper.getproducts();
//  List<AlarmBody> alarmsPersonal = [];

  for (int i = 0; i < alarms.length; i++) {
    AlarmBody item = alarms[i];

//    if (item.privacy == 'Personal') alarmsPersonal.add(item);
    DateTime date = new DateFormat("dd/MMM/yyyy hh:mm aa").parse(item.date+" "+item.time);
    printMessage(item.date+" "+item.time);
    DateTime date2 = DateTime.now();
    int difference = date2.difference(date).inMinutes;
    if(difference<1) {
      Fluttertoast.showToast(
          msg: item.description,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      printMessage("Periodic!");
      Map map1 = Map<String, dynamic>();
      map1['data'] = item.date+" "+item.time;
      map1['notification'] = item.description;
      await displayNotification(map1);
    }
  }
}

Future displayNotification(Map<String, dynamic> message) async{
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channelid', 'flutterfcm', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message['data'],
    message['notification'],
    platformChannelSpecifics,
    payload: message['data'],);
}
Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
}

void printOneShot() {
  printMessage("One shot!");
  /*Fluttertoast.showToast(
      msg: "2",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );*/
}

void printMessage(String msg) => print('[${DateTime.now()}] $msg');
class MyApp extends StatefulWidget {
  MyApp({
    this.defaultLanguage,
  });

  final String defaultLanguage;

  @override
  _MyAppState createState() => new _MyAppState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@drawable/launch_background');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }
  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
          ),
        ],
      ),
    );
  }
  Future displayNotification(Map<String, dynamic> message) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['data']['message'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: message['data']['message'],);
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Done App',
        initialRoute: "/",
        onGenerateRoute: Routes.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Tags.materialColor
        ),
        home: Scaffold(

          backgroundColor: Colors.white,
          body: SplashPage(),
        ));
  }
}
