import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../resources/routes/routes.dart';
import '../utils/constants/image_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
      //     String token = authProvider.getAuthToken();
      //     print("token : : --$token :--");
      //     if (token == '' || token == "null" ) {
      Navigator.pushReplacementNamed(context, Routes.login);
      //     } else {
      //       Navigator.pushReplacementNamed(context, Routes.getProfileDetailsScreen());
      //       // Navigator.pushReplacementNamed(
      //       //     context, Routes.getDrawerControllScreen());
      //
      //     }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(Images.applogoWithName, width: 60.w)),
          ],
        ),
      ),
    );
  }
}
