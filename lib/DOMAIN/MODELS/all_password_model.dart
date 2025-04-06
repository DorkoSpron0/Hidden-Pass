import 'dart:convert';

class AllPasswordModel {
  final String id_password;
  final String name;
  final String url;
  final String email_user;
  final String password;
  final String description;

  AllPasswordModel({
    required this.id_password,
    required this.name,
    required this.url,
    required this.email_user,
    required this.password,
    required this.description,
  });

  factory AllPasswordModel.fromJson(Map<String, dynamic> json) {
    return AllPasswordModel(
      id_password: json['id_password'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      email_user: json['email_user'] as String,
      password: json['password'] as String,
      description: json['description'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_password': id_password,
      'name': name,
      'url': url,
      'email_user': email_user,
      'password': password,
      'description': description,
    };
  }
}