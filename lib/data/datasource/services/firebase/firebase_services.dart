import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/data/models/participant.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/globles.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';

import '../../../models/event_model.dart';
import '../../../models/event_type.dart';

class FireServices {
  FireServices._();

  static FireServices get instance => _instance;
  static FireServices _instance = FireServices._();

  /// COLLECTIOINS
  CollectionReference get organizers => _organizers;
  final _organizers = FirebaseFirestore.instance.collection("organizers");

  CollectionReference get users => _users;
  final _users = FirebaseFirestore.instance.collection("users");

  CollectionReference get serverKeys => _serverKeys;
  final _serverKeys = FirebaseFirestore.instance.collection("serverKeys");

  CollectionReference get fcmTokens => _fcmTokens;
  final _fcmTokens = FirebaseFirestore.instance.collection("fcmTokens");

  // CollectionReference get userTokens => _userTokens;
  // final _userTokens = FirebaseFirestore.instance.collection("tokens");

  // CollectionReference get orgTokens => _orgTokens;
  // final _orgTokens = FirebaseFirestore.instance.collection("tokens");
  /////////////////////[ ORGANIZERS ]///////////////////////

  /// --- ORGANIZER SIGNUP - UPDATE
  ///
  Future<void> setOrganizer(
      {required String id, required OrganizerModel orgModel}) async {
    await _organizers.doc(id).set(orgModel.toJson());
  }

  Future<void> updateOrganizer(
      {required String id, required Map<String, dynamic> updatedJson}) async {
    await _organizers.doc(id).update(updatedJson);
  }

  /// --- ALL ORGANIZERS
  ///
  Future<List<OrganizerModel>> getAllOrganizers() async {
    return _organizers.get().then((org) =>
        org.docs.map((e) => OrganizerModel.fromJson(e.data())).toList());
  }

  Stream<List<OrganizerModel>> fetchAllOrganizers() {
    return _organizers.snapshots().map((org) =>
        org.docs.map((e) => OrganizerModel.fromJson(e.data())).toList());
  }

  /// --- SINGLE ORGANIZER
  ///
  Future<OrganizerModel> getSingleOrganizer({required String id}) async {
    return _organizers
        .doc(id)
        .get()
        .then((org) => OrganizerModel.fromJson(org.data() ?? {}));
  }

  Future<OrganizerModel> getCurrentOrganizer() async {
    final orgId = await Shared_Preferences.prefGetString(App.id, "");

    return _organizers
        .doc(orgId)
        .get()
        .then((org) => OrganizerModel.fromJson(org.data() ?? {}));
  }

  Stream<OrganizerModel> fetchSingleOrganizer({required String id}) {
    return _organizers
        .doc(id)
        .snapshots()
        .map((org) => OrganizerModel.fromJson(org.data() ?? {}));
  }

  /////////////////////[ USERS ]///////////////////////

  /// --- ORGANIZER SIGNUP - UPDATE
  ///
  Future<void> setUser(
      {required String id, required UserModel userModel}) async {
    await _users.doc(id).set(userModel.toJson());
  }

  Future<void> updateUser(
      {required String id, required Map<String, dynamic> updatedJson}) async {
    await _users.doc(id).update(updatedJson);
  }

  /// --- USERS
  ///
  Future<List<UserModel>> getAllUsers() async {
    return _users.get().then(
        (user) => user.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Stream<List<UserModel>> fetchAllUsers() {
    return _users.snapshots().map(
        (user) => user.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Stream<List<UserModel>> fetchUsersByOrdId({required String orgId}) {
    return _users
        .where('orgId', isEqualTo: orgId)
        .orderBy("joinDate", descending: true)
        .snapshots()
        .map((user) =>
            user.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Future<UserModel> getSingleUserByUserId({required String userId}) async {
    return _users
        .doc(userId)
        .get()
        .then((user) => UserModel.fromJson(user.data() ?? {}));
  }

  Future<List<UserModel>> getUsersByOrgId({required String orgId}) async {
    return _users.where('orgId', isEqualTo: orgId).get().then(
        (user) => user.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Future<List<UserModel>> getUsersByOrgIdMobilePassword(
      {required String orgId,
      required String mobile,
      required String password}) async {
    return _users
        .where('orgId', isEqualTo: orgId)
        .where('mobile', isEqualTo: mobile)
        .where('password', isEqualTo: password)
        .get()
        .then((user) =>
            user.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Stream<UserModel> fetchSingleUser({required String id}) {
    return _users
        .doc(id)
        .snapshots()
        .map((user) => UserModel.fromJson(user.data() ?? {}));
  }

  Future<void> deleteUser({required String userId}) async {
    await _users.doc(userId).delete();
  }

  /// --- CHANGE PASSWORD ---
  ///

  Future<void> changeOrgPassword(
      {required String orgId, required String newPass}) async {
    await _organizers.doc(orgId).update({'password': newPass});
  }

  Future<void> changeUserPassword(
      {required String userId, required String newPass}) async {
    await _users.doc(userId).update({'password': newPass});
  }

  /// --- EVENT MANAGEMENT
  ///
  /// --- ORG EVENT TYPE
  ///

  Future<bool> addEventType(
      {required String orgId,
      required String typeId,
      required EventType eventType}) async {
    await _organizers
        .doc(orgId)
        .collection(App.eventTypes)
        .doc(typeId)
        .set(eventType.toJson());
    return true;
  }

  Stream<List<EventType>> fetchEventTypeByOrg({required String orgId}) {
    return _organizers.doc(orgId).collection(App.eventTypes).snapshots().map(
        (event) =>
            event.docs.map((e) => EventType.fromJson(e.data())).toList());
  }

  Future<List<EventType>> getEventTypeByOrg({required String orgId}) async {
    return await _organizers.doc(orgId).collection(App.eventTypes).get().then(
        (event) =>
            event.docs.map((e) => EventType.fromJson(e.data())).toList());
  }

  Future<EventType> getEventTypeByTypeId(
      {required String orgId, required String typeId}) async {
    return await _organizers
        .doc(orgId)
        .collection(App.eventTypes)
        .doc(typeId)
        .get()
        .then((e) => EventType.fromJson(e.data() ?? {}));
  }

  /// --- ORG EVENT
  ///

  Future<bool> addNewEvent({
    required String orgId,
    required String eventId,
    required EventModel eventModel,
  }) async {
    await _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .set(eventModel.toJson());
    return true;
  }

  Stream<List<EventModel>> fetchEventsByTypeId({
    required String orgId,
    required String typeId,
  }) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('typeId', isEqualTo: typeId)
        .where('eventDate', isGreaterThanOrEqualTo: currentDate.toString())
        .orderBy('eventDate', descending: false)
        .orderBy('eventTime', descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Stream<List<EventModel>> fetchAllEventsByOrgId({required String orgId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isGreaterThanOrEqualTo: currentDate.toString())
        .orderBy('eventDate', descending: false)
        .orderBy('eventTime', descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Future<List<EventModel>> getEventByTypeId(
      {required String orgId, required String typeId}) async {
    return await _organizers
        .doc(orgId)
        .collection(App.events)
        .where('typeId', isEqualTo: typeId)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .get()
        .then((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

// -- fetch single event
  Stream<EventModel> fetchEventByEventId(
      {required String orgId, required String eventId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .snapshots()
        .map((event) => EventModel.fromJson(event.data() ?? {}));
  }

  Future<EventModel> getEventByEventId(
      {required String orgId, required String eventId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .get()
        .then((event) => EventModel.fromJson(event.data() ?? {}));
  }

  /// --- fetch upcoming events
  ///

  Stream<List<EventModel>> fetchUpcomingEvents({required String orgId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isGreaterThanOrEqualTo: currentDate.toString())
        .orderBy('eventDate', descending: false)
        .orderBy('eventTime', descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Future<List<EventModel>> getUpcomingEvents({required String orgId}) async {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isGreaterThanOrEqualTo: currentDate.toString())
        .orderBy('eventDate', descending: false)
        .orderBy('eventTime', descending: false)
        .get()
        .then((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  /// --- fetch past events
  ///

  Stream<List<EventModel>> fetchPastEvents({required String orgId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isLessThan: currentDate.toString())
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Future<List<EventModel>> getPastEvents({required String orgId}) async {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isLessThan: currentDate.toString())
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .get()
        .then((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  /// --- edit event

  Future<bool> editEvent({
    required String orgId,
    required String eventId,
    required Map<String, dynamic> updatedJson,
  }) async {
    await _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .update(updatedJson);
    return true;
  }

  /// --- delete event

  Future<void> deleteEvent({
    required String orgId,
    required String eventId,
  }) async {
    await _organizers.doc(orgId).collection(App.events).doc(eventId).delete();
  }

  /// --- JOIN EVENT PARICIPANTS
  ///

  Future<void> joinEventParticipant({
    required String orgId,
    required String eventId,
    required String userId,
  }) async {
    final event = await getEventByEventId(orgId: orgId, eventId: eventId);
    final participant = Participant(
        orgId: orgId,
        eventId: eventId,
        userId: userId,
        eventDate: event.eventDate,
        eventTime: event.eventTime,
        joinedDate: DateTime.now().toString());
    await _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .collection(App.participants)
        .doc(userId)
        .set(participant.toJson());
    await _users
        .doc(userId)
        .collection(App.joinedEvents)
        .doc(eventId)
        .set(participant.toJson());
  }

  Future<void> leaveEventParticipant({
    required String orgId,
    required String eventId,
    required String userId,
  }) async {
    await _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .collection(App.participants)
        .doc(userId)
        .delete();
    await _users.doc(userId).collection(App.joinedEvents).doc(eventId).delete();
  }

  Stream<bool> isUserJoinedEvent(
      {required String userId,
      required String eventId,
      required String orgId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .collection(App.participants)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((event) =>
            event.docs
                .map((e) => Participant.fromJson(e.data()))
                .toList()
                .length !=
            0);
  }

  // Future<bool> getIsUserJoinedEvent(
  //     {required String userId,
  //     required String eventId,
  //     required String orgId}) {
  //   return _organizers
  //       .doc(orgId)
  //       .collection(App.events)
  //       .doc(eventId)
  //       .collection(App.participants)
  //       .where('userId', isEqualTo: userId)
  //       .get()
  //       .then((event) =>
  //           event.docs
  //               .map((e) => Participant.fromJson(e.data()))
  //               .toList()
  //               .length !=
  //           0);
  // }

  Stream<List<Participant>> fetchJoinedParticipants(
      {required String orgId, required String eventId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .collection(App.participants)
        .orderBy('joinedDate', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Participant.fromJson(e.data())).toList());
  }

  /// --- fetch user joined upcoming and past events
  ///

  Future<List<EventModel>> fetchJoinedAllEvents(
      {required String userId}) async {
    List<EventModel> events = [];
    final participants = await _users
        .doc(userId)
        .collection(App.joinedEvents)
        .orderBy('eventDate')
        .orderBy('eventTime')
        .get()
        .then((event) =>
            event.docs.map((e) => Participant.fromJson(e.data())).toList());
    print(" --- parti leng : ${participants.length}");
    for (Participant p in participants) {
      final event =
          await getEventByEventId(orgId: p.orgId!, eventId: p.eventId!);

      events.add(event);
    }
    return events;
  }

  Future<List<EventModel>> fetchJoinedUpcomingEvents(
      {required String userId}) async {
    List<EventModel> events = [];
    final participants = await _users
        .doc(userId)
        .collection(App.joinedEvents)
        .orderBy('eventDate')
        .orderBy('eventTime')
        .get()
        .then((event) =>
            event.docs.map((e) => Participant.fromJson(e.data())).toList());
    print(" --- parti leng : ${participants.length}");
    for (Participant p in participants) {
      final event =
          await getEventByEventId(orgId: p.orgId!, eventId: p.eventId!);

      if (isAfterOrToday(event.eventDate!, currentDate.toString()))
        events.add(event);
    }
    return events;
  }

  Future<List<EventModel>> fetchJoinedPastEvents(
      {required String userId}) async {
    List<EventModel> events = [];
    final participants = await _users
        .doc(userId)
        .collection(App.joinedEvents)
        .orderBy('eventDate')
        .orderBy('eventTime')
        .get()
        .then((event) =>
            event.docs.map((e) => Participant.fromJson(e.data())).toList());
    print(" --- parti leng past : ${participants.length}");
    for (Participant p in participants) {
      final event =
          await getEventByEventId(orgId: p.orgId!, eventId: p.eventId!);
      if (!isAfterOrToday(event.eventDate!, currentDate.toString()))
        events.add(event);
    }
    return events;
  }

  bool isAfterOrToday(String dateString1, String dateString2) {
    // Parse strings into DateTime objects
    DateTime date1 = DateTime.parse(dateString1);
    DateTime date2 = DateTime.parse(dateString2);

    // Compare dates
    if (!date1.isBefore(date2)) {
      return true;
    } else {
      return false;
    }
  }

  /// ---   UPLOAD MEDIA - API KEY
  ///

  Future<String> fetchApiKey() => _serverKeys
      .doc('apiKey')
      .get()
      .then((value) => value.data()?['apiKey']);

  /// --- NOTIFICATIONS - FCM TOKENS
  ///

  Future<String> fetchServerKey() => _serverKeys
      .doc('serverKey')
      .get()
      .then((value) => value.data()?['serverKey']);

  Future<void> storeFcmToken(
      {required String id,
      required String deviceId,
      required bool isUser,
      required String token}) async {
    _fcmTokens.doc(deviceId).set(
        {"id": id, "devideId": deviceId, "isUser": isUser, "fcmToken": token});
  }

  Future<void> removeFcmToken({required String deviceId}) async {
    _fcmTokens.doc(deviceId).delete();
  }

  Future<List<String>> getUserFcmTokens({required String orgId}) =>
      _fcmTokens.where('isUser', isEqualTo: true).get().then((value) =>
          value.docs.map((e) => e.data()['fcmToken'] as String).toList());

  Future<List<String>> getOrgFcmTokens({required String userId}) =>
      _fcmTokens.where('isUser', isEqualTo: false).get().then((value) =>
          value.docs.map((e) => e.data()['fcmToken'] as String).toList());

  // Future<void> storeUserToken(
  //     {required String orgId,
  //     required String deviceId,
  //     required String token}) async {
  //   _organizers
  //       .doc(orgId)
  //       .collection(App.userTokens)
  //       .doc(deviceId)
  //       .set({"fcmToken": token});
  // }

  ///----------------
  ///--------------------------------
  ///---------------------------------------------------------
  ///--------------------------------
  ///----------------
}
// final eventmodel =
// {
//   "orgId" :"fdf",
//   "eventId" : "fdf",
//   "userId" : "user12",
//   "joinedDate" : "neon perms",

// };
