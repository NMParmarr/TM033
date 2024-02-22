import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/event_model.dart';
import 'package:eventflow/data/models/event_type.dart';
import 'package:eventflow/data/repos/notification_repo.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/api_constants.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:eventflow/utils/constants/string_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/response/api_response.dart';

class HomeProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final NotificationRepo? notificationRepo;

  HomeProvider(
      {@required this.sharedPreferences, @required this.notificationRepo});

  /// --- MAIN HOME SCREEN INDEX
  ///
  int get currentScreenIndex => _currentScreenIndex;
  int _currentScreenIndex = 0;

  void setCurrentScreenIndex({required int index, bool listen = true}) {
    _currentScreenIndex = index;
    if (listen) notifyListeners();
  }

  /// --- ADD EVENT TYPE
  ///
  Future<bool> addEventType({required String typeName}) async {
    bool res = false;
    try {
      final orgId = await sharedPreferences!.getString(App.id);
      final typeId = await FireServices.instance.organizers
          .doc(orgId)
          .collection(App.eventTypes)
          .doc()
          .id;
      final EventType eventType = EventType(
          orgId: orgId,
          typeId: typeId,
          name: typeName,
          createdAt: "${DateTime.now()}");
      await FireServices.instance
          .addEventType(orgId: orgId!, typeId: typeId, eventType: eventType);

      res = true;
    } catch (e) {
      print(" --- err add event type --- $e");
      res = false;
      showToast("Something went wrong.!");
    } finally {
      notifyListeners();
      return res;
    }
  }

  /// --- SELECTED TYPE
  ///
  String get selectedType => _selectedType;
  String _selectedType = Strings.selectType;

  void setSelectedType({required String newType, bool listen = true}) {
    _selectedType = newType;

    if (listen) notifyListeners();
  }

  /// --- EVENT DATE - TIME
  ///
  DateTime? get eventDate => _eventDate;
  DateTime? _eventDate;

  String? get eventTime => _eventTime;
  String? _eventTime;

  void setEventDate({required DateTime? date, bool listen = true}) {
    _eventDate = date;
    if (listen) notifyListeners();
  }

  void setEventTime({required String? time, bool listen = true}) {
    _eventTime = time;
    if (listen) notifyListeners();
  }

  /// --- ADD NEW EVENT
  ///

  bool get eventLoading => _eventLoading;
  bool _eventLoading = false;

  Future<bool> addNewEvent(
      {required String eventName,
      required String date,
      required String time,
      required String location,
      required String desc}) async {
    _eventLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final String? orgId = await sharedPreferences!.getString(App.id);
      final String eventId = await FireServices.instance.organizers
          .doc(orgId!)
          .collection(App.events)
          .doc()
          .id;
      final List<EventType> eventTypes =
          await FireServices.instance.getEventTypeByOrg(orgId: orgId);
      final String typeId = eventTypes[
              eventTypes.indexWhere((element) => element.name == selectedType)]
          .typeId!;
      final EventModel eventModel = EventModel(
        eventId: eventId,
        orgId: orgId,
        eventName: eventName,
        eventDate: date,
        eventTime: time,
        location: location,
        typeId: typeId,
        about: desc,
        createdAt: DateTime.now().toString(),

        ///image : null
      );

      final result = await FireServices.instance
          .addNewEvent(orgId: orgId, eventId: eventId, eventModel: eventModel);

      //// -- [ NOTIFICAION ] -- ////

      if (result) {
        List fcmTokens =
            await FireServices.instance.getUserFcmTokens(orgId: orgId);
        if (kDebugMode) {
          print("tokens : $fcmTokens");
        }
        final org = await FireServices.instance.getSingleOrganizer(id: orgId);
        ApiResponse res = await notificationRepo!
            .sendNotification(apiUrl: Apis.sendNotification, body: {
          "registration_ids": fcmTokens,
          "collapse_key": "type_a",
          "notification": {
            "title": "New Event..!",
            "body": "${org.organization!} organize new event..join now..!"
          }
        });

        if (res.response?.data != null) {
          if (kDebugMode) {
            print("res : ${res.response?.data}");
          }
        }

        // if (res.response?.data['success'] >= 1) {
        //   await firebaseServices!.storeNotification(orderNo: ++orderNo);
        //   if (kDebugMode) {
        //     print("success");
        //   }
        // }
      }
      res = true;
    } catch (e) {
      print(" --- err add new event --- $e");
      showToast("Something went wrong.!");
      res = false;
    } finally {
      _eventLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- EDIT  EVENT
  ///

  Future<bool> editEvent(
      {required String eventId,
      required String eventName,
      required String date,
      required String time,
      required String location,
      required String desc}) async {
    _eventLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final String? orgId = await sharedPreferences!.getString(App.id);
      final List<EventType> eventTypes =
          await FireServices.instance.getEventTypeByOrg(orgId: orgId!);
      final String typeId = eventTypes[
              eventTypes.indexWhere((element) => element.name == selectedType)]
          .typeId!;

      final updatedEvent = {
        "eventName": eventName,
        "eventDate": eventDate,
        "eventTime": eventTime,
        "location": location,
        "typeId": typeId,
        "about": desc,
        // "image": image,
      };

      await FireServices.instance
          .editEvent(orgId: orgId, eventId: eventId, updatedJson: updatedEvent);
      res = true;
    } catch (e) {
      print(" --- err edit event --- $e");
      showToast("Something went wrong.!");
      res = false;
    } finally {
      _eventLoading = false;
      notifyListeners();
      return res;
    }
  }
}
