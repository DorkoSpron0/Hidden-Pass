import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class PasswordHiveObject extends HiveObject{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String email_user;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String description;

  PasswordHiveObject({required this.name, required this.url, required this.email_user, required this.password, required this.description});
}