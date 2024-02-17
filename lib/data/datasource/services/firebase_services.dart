import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/app_constants.dart';

class FireServices {
  FireServices._();

  static FireServices get instance => _instance;
  static FireServices _instance = FireServices._();

  /// COLLECTIOINS
  CollectionReference get organizers => _organizers;
  final _organizers = FirebaseFirestore.instance.collection("organizers");

  CollectionReference get users => _users;
  final _users = FirebaseFirestore.instance.collection("users");

  CollectionReference get events => _events;
  final _events = FirebaseFirestore.instance.collection("events");

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
  
}

// final eventmodel =
// {
//   "id" : "user12",
//   "eventName" : "neon perms",
//   "eventDate" : "neotech",
//   "eventTime" : "orgemail@gmail.com",
//   "location" : "8141809076",
//   "type" : "90-90-8980",
//   "about" : "null",
//   "image" : "https:/neotech.com/image.jpg",
//   "createdAt" : "90-909-909",
//   "participants" : [
//     "dadfad",
//     "dfadfa",
//     "dafadf"
//   ]
// };
