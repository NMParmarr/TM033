import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

showFlushbar(BuildContext context, String title,
    {String? msg,
    Duration? duration,
    FlushbarStyle? style,
    Icon? icon,
    EdgeInsets? margin,
    double? borderRadius,
    Color? indicatorColor}) {
  Flushbar(
    flushbarStyle: style ?? FlushbarStyle.FLOATING,
    icon: icon,
    title: title,
    message: msg,
    duration: duration ?? Duration(seconds: 2),
    margin: margin ?? EdgeInsets.all(0.0),
    borderRadius: BorderRadius.circular(borderRadius ?? 0),
    leftBarIndicatorColor: indicatorColor,
  )..show(context);
}
