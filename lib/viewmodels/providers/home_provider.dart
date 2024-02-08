import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvide extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  HomeProvide({@required this.sharedPreferences});

// main home screen index

  int get currentScreenIndex => _currentScreenIndex;
  int _currentScreenIndex = 0;

  void setCurrentScreenIndex({required int index, bool listen = true}) {
    _currentScreenIndex = index;
    if (listen) notifyListeners();
  }
}
