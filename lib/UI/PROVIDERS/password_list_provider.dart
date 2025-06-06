import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import '../../DOMAIN/MODELS/all_password_model.dart';

class DataListProvider with ChangeNotifier {

  List<AllPasswordModel> _passwordList = [];
  List<Map<String, dynamic>> _notesList = [];
  List<Map<String, dynamic>> _folderList = [];

  List<AllPasswordModel> get passwordList => _passwordList;
  List<Map<String, dynamic>> get notesList => _notesList;
  List<Map<String, dynamic>> get folderList => _folderList;

  void reloadPasswordList(List<AllPasswordModel> passwords){

    _passwordList = passwords;
    notifyListeners();
  }

  void reloadNoteList(List<Map<String, dynamic>> notes){
    _notesList = notes;
    notifyListeners();
  }

  void reloadFolderList(List<Map<String, dynamic>> folders){

    _folderList = folders;
    notifyListeners();
  }
}