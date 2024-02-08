import 'package:eventflow/views/auth_screens/signup_screen.dart';
import 'package:eventflow/views/user_module/main_home_screen.dart';
import 'package:flutter/material.dart';

import '../../views/auth_screens/login_screen.dart';
import '../../views/splash_screen/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String mainHome = '/mainHome';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case mainHome:
        return MaterialPageRoute(builder: (_) => MainHomeScren());

      default:
        throw const FormatException('Route not Found');
    }
  }
}

class RouteException implements Exception {
  final String message;

  RouteException(this.message);
}
