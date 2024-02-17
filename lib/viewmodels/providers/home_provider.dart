
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

}
