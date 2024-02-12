import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';

import 'common_flushbar.dart';
import 'constants/color_constants.dart';

class Utils {
  static bool isValidEmail({required String email}) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static bool isValidMobile({required String mobile}) {
    final bool mobileValid = mobile.length == 10;
    return mobileValid;
  }

  static bool isValidLengthPassword({required String password}) {
    final bool pwdValid = password.length >= 8;
    return pwdValid;
  }

  static Future<dynamic> deleteConfirmationDialoag(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to delete ?"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Txt("Cancel", textColor: Colors.white)),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
                onPressed: () {
                  Navigator.pop(context);
                  showFlushbar(context, "Event Deleted Successfully");
                },
                child: Txt("Delete", textColor: Colors.white))
          ],
        );
      },
    );
  }

  static Future<dynamic> logoutConfirmationDialoag(BuildContext context,
      {required VoidCallback onYes}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to Logout ?"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Txt("Cancel", textColor: Colors.white)),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
                onPressed: () {
                  Navigator.pop(context);
                  onYes();
                },
                child: Txt("Logout", textColor: Colors.white))
          ],
        );
      },
    );
  }

  static Future<dynamic> deleteUserDialog(BuildContext context,
      {required String username, required VoidCallback onYes}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to delete ${username} ?"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Txt("Cancel", textColor: Colors.white)),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
                onPressed: () {
                  Navigator.pop(context);
                  onYes();
                },
                child: Txt("Delete", textColor: Colors.white))
          ],
        );
      },
    );
  }

  static Future<dynamic> joinConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to join ?"),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Icon(Icons.check_circle,
                              color: Colors.green, size: 20.w),
                          content:
                              Txt("You are now participate of this event..!"),
                        );
                      },
                    );
                  },
                  child: Txt("Join", textColor: Colors.white)),
            )
          ],
        );
      },
    );
  }
}
