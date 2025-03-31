import 'package:flutter/material.dart';

class IdUserProvider with ChangeNotifier{
  String _idUser = "";

  String get idUser => _idUser;

  Future<void> setidUser({required String idUser})async {
    _idUser = idUser;
    notifyListeners();
  } 

}