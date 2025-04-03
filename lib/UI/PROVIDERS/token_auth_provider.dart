import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/main.dart';
import 'package:provider/provider.dart';

class TokenAuthProvider with ChangeNotifier{
  String _token = "";

  String get token => _token;

  Future<void> setToken({required String token})async {
    _token = token;
    notifyListeners();
  } 

}