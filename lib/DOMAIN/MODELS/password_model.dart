class PasswordModel {
  final String urlImage;
  final String title;
  final String email;
  bool isFavorite = false;

  PasswordModel({required this.urlImage, required this.title, required this.email, this.isFavorite = false});
}