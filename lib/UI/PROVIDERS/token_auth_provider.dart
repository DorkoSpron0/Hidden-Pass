import 'package:flutter/material.dart';

class TokenAuthProvider with ChangeNotifier{
  String _token = "";

  String get token => _token;

  Future<void> setToken({required String token})async {
    _token = token;
    notifyListeners();
  } 

}