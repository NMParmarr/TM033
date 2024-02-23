import 'package:eventflow/data/datasource/services/connection/network_checker_widget.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/common_flushbar.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/image_constants.dart';
import 'package:eventflow/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../resources/routes/routes.dart';

class AuthStream extends StatefulWidget {
  const AuthStream({super.key});

  @override
  State<AuthStream> createState() => _AuthStreamState();
}

class _AuthStreamState extends State<AuthStream> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final authToken = await Shared_Preferences.prefGetString(App.token, "");
      final bool isValidToken = validateToken(authToken);

      if (isValidToken) {
        if (authToken == Strings.userLoggedIn) {
          Navigator.pushReplacementNamed(context, Routes.mainHome);
        } else if (authToken == Strings.orgLoggedIn) {
          Navigator.pushReplacementNamed(context, Routes.mainHomeOrg);
        } else {
          showFlushbar(context, "Something went wrong..!");
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    });
  }

  bool validateToken(String? token) {
    return (token != null && token != "");
  }

  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Image.asset(Images.loadingGif)),
      ),
    );
  }
}
