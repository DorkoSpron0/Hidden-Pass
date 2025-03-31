import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class NoteHiveObject extends HiveObject{
  @HiveField(0)
  final String priorityName;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  NoteHiveObject(this.priorityName, this.title, this.description);
}