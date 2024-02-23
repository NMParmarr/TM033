import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  } else {
    return null;
  }
}

String formattedTime(BuildContext context, {required TimeOfDay time, bool hrs24 = false}) {
  final localizations = MaterialLocalizations.of(context);
  return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: hrs24);
}

TimeOfDay timeOfDayFromString(String time) {
  int hh = 0;
  if (time.endsWith('PM')) hh = 12;
  time = time.split(' ')[0];
  return TimeOfDay(
    hour: hh + int.parse(time.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
    minute: int.parse(time.split(":")[1]) % 60,
  );
}

String get12HrsTime(BuildContext context, {required String time}){
  final timeOfDay = timeOfDayFromString(time);
  return formattedTime(context, time: timeOfDay);
}