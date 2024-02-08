import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  AuthProvider({@required this.sharedPreferences});

  // password for user
  bool get isUserPassVisible => _isUserPassVisible;
  bool _isUserPassVisible = false;

  void toggleUserPass({bool listen = true}) {
    _isUserPassVisible = !_isUserPassVisible;
    if (listen) notifyListeners();
  }

  //password for org
  bool get isOrgPassVisible => _isOrgPassVisible;
  bool _isOrgPassVisible = false;

  bool get isOrgCPassVisible => _isOrgCPassVisible;
  bool _isOrgCPassVisible = false;

  void toggleOrgPass({bool listen = true}) {
    _isOrgPassVisible = !_isUserPassVisible;
    if (listen) notifyListeners();
  }

  void toggleOrgCPass({bool listen = true}) {
    _isOrgCPassVisible = !_isOrgCPassVisible;
    if (listen) notifyListeners();
  }
}
