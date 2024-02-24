import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import '../../utils/constants/app_constants.dart';
import 'package:eventflow/data/models/user_model.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  ProfileProvider({@required this.sharedPreferences});

   Future<void> refresh() async {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      notifyListeners();
    });
  }

  /// --- USER DETAIL UPDATE
  ///

  bool get saveUserLoading => _saveUserLoading;
  bool _saveUserLoading = false;

  Future<bool> updateUserDetails(
      {required Map<String, dynamic> updatedJsonData}) async {
    _saveUserLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final userId = await sharedPreferences!.getString(App.id);
      await FireServices.instance
          .updateUser(id: userId!, updatedJson: updatedJsonData);
      res = true;
    } catch (e) {
      print(" --- err update org : $e");
      showToast("Something went wrong");
      res = false;
    } finally {
      _saveUserLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- ORG DETAIL UPDATE
  ///

  bool get saveLoading => _saveLoading;
  bool _saveLoading = false;

  Future<bool> updateOrgDetails(
      {required Map<String, dynamic> updatedJsonData}) async {
    _saveLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final org = await FireServices.instance.getCurrentOrganizer();
      await FireServices.instance
          .updateOrganizer(id: org.id!, updatedJson: updatedJsonData);
      res = true;
    } catch (e) {
      print(" --- err update org : $e");
      showToast("Something went wrong");
      res = false;
    } finally {
      _saveLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- PICK PROFILE PICTURE
  ///
  String get imagePath => _imagePath;
  String _imagePath = "";

  // Future<String> pickImage({required ImageS})

  /// --- ADD NEW USER
  ///

  bool get newUserLoading => _newUserLoading;
  bool _newUserLoading = false;

  Future<bool> addNewUser(
      {required String orgId,
      required String fullName,
      required String mobile,
      required String password}) async {
    _newUserLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final userId = FireServices.instance.users.doc().id;
      await FireServices.instance.setUser(
          id: userId,
          userModel: UserModel(
              id: userId,
              orgId: orgId,
              name: fullName,
              mobile: mobile,
              password: password,
              isProfileCompleted: false,
              joinDate: "${DateTime.now()}"));
      res = true;
    } catch (e) {
      print(" --- err add new user : $e");
      showToast("Something went wrong..!");
      res = false;
    } finally {
      _newUserLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- DELETE USER
  ///
  bool get deleteUserLoading => _deleteUserLoading;
  bool _deleteUserLoading = false;
  Future<bool> deleteUser({required String userId}) async {
    // _deleteUserLoading = true;
    // notifyListeners();
    bool res = false;
    try {
      await FireServices.instance.deleteUser(userId: userId);
      res = true;
    } catch (e) {
      print(" --- err delet user : $e");
      showToast("Something went wrong..!");
      res = false;
    } finally {
      // _deleteUserLoading = false;
      // notifyListeners();
      return res;
    }
  }

  /// --- ADD NEW DOB OF USER
  ///
  DateTime? get dob => _dob;
  DateTime? _dob;

  void setUserDOB({required DateTime? dob, bool listen = true}) {
    _dob = dob;

    if (listen) notifyListeners();
  }

  void clearUserDOB({bool listen = true}) {
    _dob = null;

    if (listen) notifyListeners();
  }

  /// --- CHANGE PASSWORD - USER/ORG
  ///
  bool get changePassLoading => _changePassLoading;
  bool _changePassLoading = false;

  Future<bool> changePassword(
      {required String currentPass,
      required String newPass,
      required bool isUser}) async {
    _changePassLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final String? id = await sharedPreferences!.getString(App.id);
      if (isUser) {
        final user =
            await FireServices.instance.getSingleUserByUserId(userId: id!);
        if (user.password! != currentPass) {
          showToast("Invalid password..!");
          res = false;
        } else {
          FireServices.instance
              .changeUserPassword(userId: id, newPass: newPass);
          res = true;
        }
      } else {
        final org = await FireServices.instance.getSingleOrganizer(id: id!);
        if (org.password! != currentPass) {
          showToast("Invalid password..!");
          res = false;
        } else {
          FireServices.instance.changeOrgPassword(orgId: id, newPass: newPass);
          res = true;
        }
      }
    } catch (e) {
      print(" --- err change password --- $e");
      showToast("Something went wrong.!");
      res = false;
    } finally {
      _changePassLoading = false;
      notifyListeners();
      return res;
    }
  }
}
