import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hive/hive.dart';

class PasswordHiveAdapter extends TypeAdapter<PasswordHiveObject> {
  @override
  final int typeId = 1;

  @override
  PasswordHiveObject read(BinaryReader reader) {
    return PasswordHiveObject(
        name: reader.readString(),
        url: reader.readString(),
        email_user: reader.readString(),
        password: reader.readString(),
        description: reader.readString()
    );
  }

  @override
  void write(BinaryWriter writer, PasswordHiveObject obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.email_user);
    writer.writeString(obj.password);
    writer.writeString(obj.url);
  }
}
