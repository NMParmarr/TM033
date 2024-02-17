import 'package:eventflow/views/auth_screens/auth_stream.dart';
import 'package:eventflow/views/auth_screens/signup_screen.dart';
import 'package:eventflow/views/organizer_module/add_new_event_screen.dart';
import 'package:eventflow/views/organizer_module/event_details_org_screen.dart';
import 'package:eventflow/views/user_module/event_details_screen.dart';
import 'package:eventflow/views/organizer_module/main_home_org_screen.dart';
import 'package:eventflow/views/common_module_screens/change_password_screen.dart';
import 'package:eventflow/views/user_module/edit_profile_screen.dart';
import 'package:eventflow/views/user_module/main_home_screen.dart';
import 'package:flutter/material.dart';

import '../../views/auth_screens/login_screen.dart';
import '../../views/organizer_module/edit_org_profile_screen.dart';
import '../../views/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String mainHome = '/mainHome';
  static const String mainHomeOrg = '/mainHomeOrg';
  static const String eventDetails = '/eventDetails';
  static const String eventDetailsOrg = '/eventDetailsOrg';
  static const String editProfile = '/editProfile';
  static const String editOrgProfile = '/editOrgProfile';
  static const String changePassword = '/changePassword';
  static const String addEvent = '/addEvent';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case auth:
        return MaterialPageRoute(builder: (_) => AuthStream());

      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case mainHome:
        return MaterialPageRoute(builder: (_) => MainHomeScren());

      case mainHomeOrg:
        return MaterialPageRoute(builder: (_) => MainHomeOrgScreen());

      case eventDetails:
        return MaterialPageRoute(builder: (_) => EventDetailsScreen());

      case eventDetailsOrg:
        return MaterialPageRoute(builder: (_) => EventDetailsOrgScreen());

      case editProfile:
      final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => EditProfileScreen(user: args?['user']));

      case editOrgProfile:
      final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => EditOrgProfileScreen(org: args?['org']));

      case changePassword:
      final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(builder: (_) => ChangePasswordScreen(isUser:args['isUser'] ));

      case addEvent:
        return MaterialPageRoute(builder: (_) => AddEventScren());

      default:
        throw const FormatException('Route not Found');
    }
  }
}

class RouteException implements Exception {
  final String message;

  RouteException(this.message);
}
