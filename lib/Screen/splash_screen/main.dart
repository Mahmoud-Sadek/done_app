import 'package:done_app/routes/Routes.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
