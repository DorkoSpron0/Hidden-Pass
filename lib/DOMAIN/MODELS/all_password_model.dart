class AllPasswordModel {
  final String id_password;
  final String name;
  final String url;
  final String email_user;
  final String password;
  final String description;
  

  AllPasswordModel({required this.id_password, required this.name, required this.url, required this.email_user, required this.password, required this.description});

  factory AllPasswordModel.fromJson(Map<String, dynamic> json) {
    return AllPasswordModel(
      id_password: json['id_password'],
      name: json['name'],
      url: json['url'],
      email_user: json['email_user'],
      password: json['password'],
      description: json['description']
    );
  }
}
