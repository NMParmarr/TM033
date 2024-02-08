import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../globles.dart';

///common toast for user
Future<bool?> showToast(String msg, {String? bgColor, String? color}) {
  return
    Fluttertoast.showToast(
        // backgroundColor: Colors.white,
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 2.t,
        // textColor: Colors.black,
        gravity: ToastGravity.BOTTOM
    );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToastSnackbarError(BuildContext? context,String msg, {String? bgColor, String? color}) {
  final SnackBar snackBar = SnackBar(backgroundColor: Colors.red,
      content: Text(msg,style: TextStyle(color: Colors.white, fontSize: 2.t)), duration: Duration(milliseconds: 600),);
  return snackbarKey.currentState!.showSnackBar(snackBar);

}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToastSnackbarSuccess(BuildContext context,String msg, {String? bgColor, String? color}) {

  final SnackBar snackBar = SnackBar(backgroundColor: Colors.green,
      content: Text(msg,style: TextStyle(color: Colors.white)));
  return snackbarKey.currentState!.showSnackBar(snackBar);


}
