import 'package:eventflow/data/datasource/services/firebase_services.dart';
import 'package:eventflow/data/models/organizer_model.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  HomeProvider({@required this.sharedPreferences});

  /// --- MAIN HOME SCREEN INDEX
  ///
  int get currentScreenIndex => _currentScreenIndex;
  int _currentScreenIndex = 0;

  void setCurrentScreenIndex({required int index, bool listen = true}) {
    _currentScreenIndex = index;
    if (listen) notifyListeners();
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
      return res;
    }
  }

  /// --- PICK PROFILE PICTURE
  /// 
  String get imagePath => _imagePath;
  String _imagePath = "";

  // Future<String> pickImage({required ImageS})

}
