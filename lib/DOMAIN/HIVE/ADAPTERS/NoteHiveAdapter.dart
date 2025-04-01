// import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
// import 'package:hive/hive.dart';

// class NoteHiveAdapter extends TypeAdapter<NoteHiveObject> {
//   @override
//   final int typeId = 0;

//   @override
//   NoteHiveObject read(BinaryReader reader) {
//     return NoteHiveObject(
//       idNota: reader.readString(),
//       priorityName: reader.readString(),
//       title: reader.readString(),
//       description: reader.readString(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, NoteHiveObject obj) {
//     writer.writeString(obj.idNota);
//     writer.writeString(obj.priorityName);
//     writer.writeString(obj.title);
//     writer.writeString(obj.description);
//   }
// }
