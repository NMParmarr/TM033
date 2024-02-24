import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'common_flushbar.dart';
import 'common_toast.dart';
import 'constants/color_constants.dart';
import 'constants/image_constants.dart';

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

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static Future<dynamic> deleteConfirmationDialoag(BuildContext context,
      {required String eventName, required Function onDeleteEvent}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to delete '${eventName}'?"),
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
                  onDeleteEvent();
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

  static Future<dynamic> joinConfirmationDialog(BuildContext pctx,
      {required String orgId,
      required String userId,
      required String eventId}) {
    return showDialog(
      context: pctx,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to join ?"),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showLoader(pctx);
                    await FireServices.instance.joinEventParticipant(
                        orgId: orgId, eventId: eventId, userId: userId);
                    hideLoader();
                    await showDialog(
                      context: pctx,
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

  static Future<dynamic> leaveConfirmationDialog(BuildContext pctx,
      {required String orgId,
      required String userId,
      required String eventId}) {
    return showDialog(
      context: pctx,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to leave ?"),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.orange),
                  onPressed: () async {
                    Navigator.pop(context);
                    showLoader(pctx);
                    await FireServices.instance.leaveEventParticipant(
                        orgId: orgId, eventId: eventId, userId: userId);
                    hideLoader();
                    showFlushbar(
                        pctx, "You are no more participate of this event..!");
                  },
                  child: Txt("Leave", textColor: Colors.white)),
            )
          ],
        );
      },
    );
  }

  static Widget noDataFoundWidget(
      {required String msg,
      double? height,
      double? width,
      Alignment? alignment}) {
    return Container(
      color: Colors.white,
      height: height,
      width: width,
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.noDataFound2,
            height: 30.h,
          ),
          Txt(msg, fontsize: 3.t, textColor: AppColor.theme)
        ],
      ),
    );
  }

  static Future<String> pickImage(
      {required ImageSource source, bool listen = true}) async {
    String imagePath = "";
    try {
      final image = await ImagePicker().pickImage(
          source: source, maxWidth: 1280, maxHeight: 720, imageQuality: 100);

      if (image == null) return "";
      imagePath = image.path;
    } catch (e) {
      print(" --> --> err pick image : $e");
      showToast("Unexpected error occured..!");
    } finally {
      return imagePath;
    }
  }
}
