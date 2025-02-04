import 'package:hidden_pass/DOMAIN/MODELS/password_model.dart';

class FolderModel {
  final String title;
  final String description;
  final String url;
  List<PasswordModel> passwordList;

  FolderModel({required this.title, required this.description, required this.url, this.passwordList = const []});
}