import 'package:done_app/Screen/add_date_screen/AddDateScreen.dart';
import 'package:done_app/Screen/home_screen/HomeScreen.dart';
import 'package:done_app/Screen/login_screen/LoginScreen.dart';
import 'package:done_app/Screen/profile_screen/ProfileScreen.dart';
import 'package:done_app/Screen/settings_screen/SettingScreen.dart';
import 'package:done_app/Screen/splash_screen/SplashScreen.dart';
import 'package:done_app/Screen/terms_about_screen/TermsAboutScreen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    String name = settings.name;

    switch (name) {
      case "/":
        return MaterialPageRoute(builder: (BuildContext context) {
          return SplashPage();
        });

      case "/loginScreen":
        return MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
        });

      case "/homeScreen":
        return MaterialPageRoute(builder: (BuildContext context) {
          return HomeScreen();
        });

      case "/profileScreen":
        return MaterialPageRoute(builder: (BuildContext context) {
          return ProfileScreen();
        });

      case "/settingScreen":
        return MaterialPageRoute(builder: (BuildContext context) {
          return SettingScreen();
        });


      case "/termsScreen":
        int _type = settings.arguments;
        return MaterialPageRoute(builder: (BuildContext context) {
          return TermsAboutScreen(_type);
        });

      case "/addDateScreen":
        return MaterialPageRoute(builder: (BuildContext context) {
          return AddDateScreen();
        });

    }
  }
}
