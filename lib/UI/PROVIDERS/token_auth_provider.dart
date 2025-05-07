import 'package:flutter/material.dart';

class TokenAuthProvider with ChangeNotifier {
  String _token = "";
  String? _username = "";
  String? _avatarUrl;

  String get token => _token;
  String? get username => _username;
  String? get avatar => _avatarUrl;

  // Método para configurar el token, username y avatar
  Future<void> setToken({required String token, required String username, required String avatarUrl}) async {
    _token = token;
    _username = username;
    _avatarUrl = avatarUrl;
    notifyListeners();
  }
}
