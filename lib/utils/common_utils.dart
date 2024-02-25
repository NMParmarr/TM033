import 'package:device_info/device_info.dart';
import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/resources/helper/loader.dart';
import 'package:eventflow/utils/gap.dart';
import 'package:eventflow/utils/size_config.dart';
import 'package:eventflow/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/providers/media_provider.dart';
import 'common_flushbar.dart';
import 'common_toast.dart';
import 'constants/color_constants.dart';
import 'constants/image_constants.dart';

enum RequestType {
  camera,
  storage,
}

class Utils {
  static bool isValidEmail({required String email}) {
    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
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

  static 
  Future<dynamic> aboutAppDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              backgroundColor: Color.fromARGB(255, 224, 224, 224),
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 12.w,
                      width: 12.w,
                      child: Image.asset(Images.applogoRounded),
                    ),
                    HGap(2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Txt(
                          "EventFlow",
                          fontsize: 2.6.t,
                          fontweight: FontWeight.bold,
                          // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Txt(
                          "Version : 1.0.0",
                          fontsize: 1.7.t,
                          fontweight: FontWeight.w400,
                          textColor: Color.fromARGB(255, 95, 95, 95),
                        )
                      ],
                    )
                  ],
                ),
                VGap(2.h),
                Txt("Developed by Nayan Parmar", fontsize: 2.2.t, fontweight: FontWeight.w500),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final Uri url = Uri.parse("https://nmparmarr.github.io/i/");

                    if (!await launchUrl(url)) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some error occured..try again later..!")));
                    }
                  },
                  child: Txt("https://nmparmarr.github.io/i/", fontsize: 1.9.t, fontweight: FontWeight.w400, textColor: Color.fromARGB(255, 0, 108, 196)),
                ),
                HGap(1.h)
              ],
            ));
  }

  static Future<dynamic> deleteConfirmationDialoag(BuildContext context, {required String eventName, required Function onDeleteEvent}) {
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
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

  static Future<dynamic> logoutConfirmationDialoag(BuildContext context, {required VoidCallback onYes}) {
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
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

  static Future<dynamic> deleteUserDialog(BuildContext context, {required String username, required VoidCallback onYes}) {
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
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

  static Future<dynamic> joinConfirmationDialog(BuildContext pctx, {required String orgId, required String userId, required String eventId}) {
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
                    await FireServices.instance.joinEventParticipant(orgId: orgId, eventId: eventId, userId: userId);
                    hideLoader();
                    await showDialog(
                      context: pctx,
                      builder: (context) {
                        return AlertDialog(
                          title: Icon(Icons.check_circle, color: Colors.green, size: 20.w),
                          content: Txt("You are now participate of this event..!"),
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

  static Future<dynamic> leaveConfirmationDialog(BuildContext pctx, {required String orgId, required String userId, required String eventId}) {
    return showDialog(
      context: pctx,
      builder: (context) {
        return AlertDialog(
          title: Txt("Are you sure to leave ?"),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
                  onPressed: () async {
                    Navigator.pop(context);
                    showLoader(pctx);
                    await FireServices.instance.leaveEventParticipant(orgId: orgId, eventId: eventId, userId: userId);
                    hideLoader();
                    showFlushbar(pctx, "You are no more participate of this event..!");
                  },
                  child: Txt("Leave", textColor: Colors.white)),
            )
          ],
        );
      },
    );
  }

  static Widget noDataFoundWidget({required String msg, double? height, double? width, Alignment? alignment}) {
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

  static Future<String> pickImage(BuildContext context,
      {required ImageSource source,
      bool showSaveToast = false,
      required List<CropAspectRatioPreset> aspectRatioPresets,
      required Future<String> Function(BuildContext context, {required String imagePath, required List<CropAspectRatioPreset> aspectRatioPresets}) cropImage,
      double? maxWidth,
      double? maxHeight,
      bool listen = true}) async {
    String imagePath = "";
    try {
      final image = await ImagePicker().pickImage(source: source, maxWidth: maxWidth ?? 1280, maxHeight: maxHeight ?? 720, imageQuality: 100);

      if (image == null) return "";
      imagePath = await cropImage(context, imagePath: image.path, aspectRatioPresets: aspectRatioPresets);
    } catch (e) {
      print(" --> --> err pick image : $e");
      showToast("Unexpected error occured..!");
    } finally {
      if (showSaveToast) showToast("Don't forget to save..!");
      return imagePath;
    }
  }

  static Future<String> cropImage(BuildContext context, {required String imagePath, required List<CropAspectRatioPreset> aspectRatioPresets}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,

      aspectRatioPresets: aspectRatioPresets,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9,
      // ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColor.theme,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: true,
            activeControlsWidgetColor: AppColor.theme),
        IOSUiSettings(
          title: 'Crop Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return croppedFile?.path ?? '';
  }

  static Future showImagePickOptionDialog(BuildContext context, {required List<CropAspectRatioPreset> aspectRatioPresets, bool showSaveToast = false, double? maxWidth, double? maxHeight}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Consumer<MediaProvider>(builder: (context, provider, _) {
            return SimpleDialog(
              children: [
                SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      final bool isGranted = await requestPermission(requestType: RequestType.camera);
                      if (!isGranted) {
                        showToast("Permission denied..!");
                        return;
                      }
                      String imagePath = await pickImage(context,
                          source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight, cropImage: cropImage, aspectRatioPresets: aspectRatioPresets, showSaveToast: showSaveToast);
                      provider.setImagePath(newPath: imagePath);
                    },
                    child: Row(children: [Icon(Icons.camera_alt_outlined), HGap(3.w), Txt("Choose from camera")])),
                SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      final bool isGranted = await requestPermission(requestType: RequestType.storage);
                      if (!isGranted) {
                        showToast("Permission denied..!");
                        return;
                      }
                      String imagePath = await pickImage(context,
                          source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight, cropImage: cropImage, aspectRatioPresets: aspectRatioPresets, showSaveToast: showSaveToast);
                      provider.setImagePath(newPath: imagePath);
                    },
                    child: Row(children: [Icon(Icons.image_outlined), HGap(3.w), Txt("Choose from gallery")])),
              ],
            );
          });
        });
  }

  static Future<bool> requestPermission({required RequestType requestType}) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (requestType == RequestType.storage) {
        if (await Permission.storage.request().isGranted) {
          return true;
        } else if (await Permission.storage.request().isPermanentlyDenied) {
          await openAppSettings();
          return false;
        } else {
          return false;
        }
      } else {
        if (await Permission.camera.request().isGranted) {
          return true;
        } else if (await Permission.camera.request().isPermanentlyDenied) {
          await openAppSettings();
          return false;
        } else {
          return false;
        }
      }
    } else {
      return true;
    }
  }
}
