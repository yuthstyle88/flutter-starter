import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/user/login.dart';
import 'package:boilerplate/ui/user/signup.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:boilerplate/ui/user/update_user.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String update_user = '/update_user';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    signup: (BuildContext context) => SignupScreen(),
    update_user: (BuildContext context) => UpdateUserScreen(),
  };
}
