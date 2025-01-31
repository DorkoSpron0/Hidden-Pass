import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier{
  int _index = 0;

  int get index => _index;

  Future<void> setNavigationIndex({required int index})async {
    _index = index;
    notifyListeners();
  }
}