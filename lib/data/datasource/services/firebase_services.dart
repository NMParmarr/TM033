import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/constants/app_constants.dart';

import '../../models/event_model.dart';
import '../../models/event_type.dart';

class FireServices {
  FireServices._();

  static FireServices get instance => _instance;
  static FireServices _instance = FireServices._();

  /// COLLECTIOINS
  CollectionReference get organizers => _organizers;
  final _organizers = FirebaseFirestore.instance.collection("organizers");

  CollectionReference get users => _users;
  final _users = FirebaseFirestore.instance.collection("users");

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

  Future<void> addEventType(
      {required String orgId,
      required String typeId,
      required EventType eventType}) async {
    await _organizers
        .doc(orgId)
        .collection(App.eventTypes)
        .doc(typeId)
        .set(eventType.toJson());
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

  /// --- ORG EVENT
  ///

  Future<void> addNewEvent({
    required String orgId,
    required String eventId,
    required EventModel eventModel,
  }) async {
    await _organizers
        .doc(orgId)
        .collection(App.events)
        .doc(eventId)
        .set(eventModel.toJson());
  }

  Stream<List<EventModel>> fetchEventsByTypeId(
      {required String orgId, required String typeId}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('typeId', isEqualTo: typeId)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
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

  Stream<List<EventModel>> fetchUpcomingEvents(
      {required String orgId, required String todayDate}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isGreaterThanOrEqualTo: todayDate)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Future<List<EventModel>> getUpcomingEvents(
      {required String orgId, required String todayDate}) async {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isGreaterThanOrEqualTo: todayDate)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .get()
        .then((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }
  /// --- fetch past events
  ///

  Stream<List<EventModel>> fetchPastEvents(
      {required String orgId, required String todayDate}) {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isLessThan: todayDate)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  Future<List<EventModel>> getPastEvents(
      {required String orgId, required String todayDate}) async {
    return _organizers
        .doc(orgId)
        .collection(App.events)
        .where('eventDate', isLessThan: todayDate)
        .orderBy('eventDate', descending: true)
        .orderBy('eventTime', descending: true)
        .get()
        .then((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  ///----------------
  ///--------------------------------
  ///---------------------------------------------------------
  ///--------------------------------
  ///----------------
}
// final eventmodel =
// {
//   "typeId" : "user12",
//   "orgId" : "neon perms",
//   "name" : "neotech",

// };
