// ignore_for_file: unused_local_variable, await_only_futures, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../resources/helper/shared_preferences.dart';

class FireMessaging {
  FireMessaging._();

  static FireMessaging get instance => _instance;
  static final _instance = FireMessaging._();

  final _flutterLocalNotification = FlutterLocalNotificationsPlugin();

  Future<void> initMessaging() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> storeFcmToken() async {
    final messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();

    Shared_Preferences.prefSetString("FCMTOKEN", token!);
  }

  Future<void> listenMessaging(BuildContext context) async {
    ///
    /// DISPLAY MESSAGE WHEN APP IS ACTIVATE..LOCAL NOTIFICATION
    ///
    await FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        if (Platform.isAndroid) {
          await initLocalNotifications(context, message);
          await showNotification(message);
        }
        if (Platform.isIOS) {
          forgroundMessage();
        }
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _handleMessage(context, event);
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///
  ///

  Future<void> initLocalNotifications(
      BuildContext? context, RemoteMessage? message) async {
    if (kDebugMode) {
      print(" --> Local Notification initilized <-- ");
    }
    var androidInitialization = const AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iosInitializetion = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iosInitializetion);

    await _flutterLocalNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      if (kDebugMode) {
        print("called handle messsagwe ");
      }
      if (message != null) _handleMessage(context!, message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    //
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      "${DateTime.now().millisecondsSinceEpoch / ~1000}",
      "Eventflow Notificatrion",
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "EventFlow - Flow of Events",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotification.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    if (kDebugMode) {
      print("navigate to notificaton screen before");
    }
    // Navigator.pushNamed(context, Routes.notification);
    if (kDebugMode) {
      print("navigate to notificaton screen after");
    }
  }
}
