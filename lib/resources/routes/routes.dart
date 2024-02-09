import 'package:eventflow/views/auth_screens/signup_screen.dart';
import 'package:eventflow/views/common_screens/event_details_screen.dart';
import 'package:eventflow/views/user_module/change_password_screen.dart';
import 'package:eventflow/views/user_module/edit_profile_screen.dart';
import 'package:eventflow/views/user_module/main_home_screen.dart';
import 'package:flutter/material.dart';

import '../../views/auth_screens/login_screen.dart';
import '../../views/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String mainHome = '/mainHome';
  static const String eventDetails = '/eventDetails';
  static const String editProfile = '/editProfile';
  static const String changePassword = '/changePassword';

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

      case eventDetails:
        return MaterialPageRoute(builder: (_) => EventDetailsScreen());

      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case changePassword:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      default:
        throw const FormatException('Route not Found');
    }
  }
}

class RouteException implements Exception {
  final String message;

  RouteException(this.message);
}
