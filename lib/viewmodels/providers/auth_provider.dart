import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/resources/helper/shared_preferences.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:eventflow/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/organizer_model.dart';
import '../../utils/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  AuthProvider({@required this.sharedPreferences});

  // // TEXT CONTROLER --- ORGANIZERS
  // TextEditingController? _orgTionCtr;
  // TextEditingController? _orgZerCtr;
  // TextEditingController? _orgEmailCtr;
  // TextEditingController? _orgMobileCtr;
  // TextEditingController? _orgPassCtr;
  // TextEditingController? _orgCpassCtr;

  // TextEditingController get orgTionCtr => _orgTionCtr!;
  // TextEditingController get orgZerCtr => _orgZerCtr!;
  // TextEditingController get orgEmailCtr => _orgEmailCtr!;
  // TextEditingController get orgMobileCtr => _orgMobileCtr!;
  // TextEditingController get orgPassCtr => _orgPassCtr!;
  // TextEditingController get orgCpassCtr => _orgCpassCtr!;

  // void initTextControllers({bool listen = false}) {
  //   _orgTionCtr = TextEditingController();
  //   _orgZerCtr = TextEditingController();
  //   _orgEmailCtr = TextEditingController();
  //   _orgMobileCtr = TextEditingController();
  //   _orgPassCtr = TextEditingController();
  //   _orgCpassCtr = TextEditingController();
  //   if (listen) notifyListeners();
  // }

  // void clearTextControllers({bool listen = true}) {
  //   _orgTionCtr?.clear();
  //   _orgZerCtr?.clear();
  //   _orgEmailCtr?.clear();
  //   _orgMobileCtr?.clear();
  //   _orgPassCtr?.clear();
  //   _orgCpassCtr?.clear();
  //   if (listen) notifyListeners();
  // }

  // void disposeTextControllers({bool listen = false}) {
  //   _orgTionCtr?.dispose();
  //   _orgZerCtr?.dispose();
  //   _orgEmailCtr?.dispose();
  //   _orgMobileCtr?.dispose();
  //   _orgPassCtr?.dispose();
  //   _orgCpassCtr?.dispose();
  //   if (listen) notifyListeners();
  // }

  /// --- PASSWORD FOR USER
  ///
  bool get isUserPassVisible => _isUserPassVisible;
  bool _isUserPassVisible = false;

  void toggleUserPass({bool listen = true}) {
    _isUserPassVisible = !_isUserPassVisible;
    if (listen) notifyListeners();
  }

  /// --- PASSWORD FOR ORG
  ///
  bool get isOrgPassVisible => _isOrgPassVisible;
  bool _isOrgPassVisible = false;

  bool get isOrgCPassVisible => _isOrgCPassVisible;
  bool _isOrgCPassVisible = false;

  void toggleOrgPass({bool listen = true}) {
    _isOrgPassVisible = !_isOrgPassVisible;
    if (listen) notifyListeners();
  }

  void toggleOrgCPass({bool listen = true}) {
    _isOrgCPassVisible = !_isOrgCPassVisible;
    if (listen) notifyListeners();
  }

  /// --- SIGNUP ORG
  ///
  bool get signupLoading => _signupLoading;
  bool _signupLoading = false;

  Future<bool> signUpOrganizer(
      {required String id, required OrganizerModel orgModel}) async {
    bool res = false;
    _signupLoading = true;
    notifyListeners();
    try {
      await FireServices.instance.setOrganizer(id: id, orgModel: orgModel);
      res = true;
    } catch (e) {
      res = false;
      print("--- err signup org : $e");
      showToast("Something went wrong..!");
    } finally {
      _signupLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- LOGIN ORG
  ///
  bool get orgLoginLoading => _orgLoginLoading;
  bool _orgLoginLoading = false;

  Future<bool> loginOrg(
      {required String mobile, required String password}) async {
    _orgLoginLoading = true;
    notifyListeners();
    bool res = false;
    try {
      final organization = _orgList
          .firstWhere((element) => element.organization == selectedValue);
      final OrganizerModel org =
          await FireServices.instance.getSingleOrganizer(id: organization.id!);
      if (matchTwoString(org.mobile!, mobile)) {
        if (matchTwoString(org.password!, password)) {
          res = true;
          await Shared_Preferences.prefSetString(
              App.token, Strings.orgLoggedIn);
          await Shared_Preferences.prefSetString(App.id, org.id!);
        } else {
          res = false;
          showToast("Invalid password");
        }
      } else {
        res = false;
        showToast("Invalid mobile no");
      }
    } catch (e) {
      print(" --- err login org : $e");
      showToast("Something went wrong..!");
      res = false;
    } finally {
      _orgLoginLoading = false;
      return res;
    }
  }

  bool matchTwoString(String s1, String s2) {
    return s1 == s2;
  }

  /// --- LOGOUT ORG
  ///
  bool get logoutLoading => _logoutLoading;
  bool _logoutLoading = false;
  Future<bool> logout() async {
    _logoutLoading = true;
    notifyListeners();
    bool res = false;
    try {
      // await sharedPreferences!.clear();
      await Shared_Preferences.clearAllPref();
      res = true;
    } catch (e) {
      print(" --- err logout : $e");
      showToast("Something went wrong..!");
      res = false;
    } finally {
      _logoutLoading = false;
      notifyListeners();
      return res;
    }
  }

  /// --- ORG DROPDOWN
  ///
  String get selectedValue => _selectedValue;
  String _selectedValue = Strings.selectOrgTion;

  List<OrganizerModel> get orgList => _orgList;
  List<OrganizerModel> _orgList = [];

  void initOrgListSelection({bool listen = false}) {
    _orgList.insert(0, OrganizerModel(organization: Strings.selectOrgTion));
    if (listen) notifyListeners();
  }

  void setDropdownValue({required String value, bool listen = true}) {
    _selectedValue = value;
    if (listen) notifyListeners();
  }

  void setOrgList(
      {required List<OrganizerModel> orgListData, bool listen = true}) {
    _orgList = orgListData;
    initOrgListSelection(listen: listen);
    if (listen) notifyListeners();
  }
}
