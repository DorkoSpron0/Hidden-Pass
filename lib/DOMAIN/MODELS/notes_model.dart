class NoteModel {
  final String title;
  final String description;
  final bool isFavorite;

  NoteModel({required this.title, required this.description, this.isFavorite = false});
}