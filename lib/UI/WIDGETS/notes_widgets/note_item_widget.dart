import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/notes/edit_notes_screen.dart';
import 'package:hidden_pass/UI/SCREENS/notes/see_notes_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String idNote;
  final String priorityName;
  final VoidCallback onDelete;

  NoteItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.idNote,
    required this.priorityName,
    required this.onDelete,
  });

  // Función para eliminar la nota
  void deleteNote(BuildContext context) async {
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      final box = Hive.box<NoteHiveObject>('notes');

      Future<bool> tituloExiste(String title) async {
        return box.values.any((note) => note.title == title);
      }

      if (await tituloExiste(title) == true) {
        box.delete(title);
      }
    } else {
      var url = Uri.parse(ApiConfig.endpoint("/notes/$idNote"));


      try {
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print("Nota eliminada en el servidor: $idNote");
          Provider.of<DataListProvider>(context, listen: false).reloadNoteList(<Map<String, dynamic>>[]);
        } else {
          print("Error al eliminar en el backend: ${response.body}");
        }
      } catch (e) {
        print("Error de conexión al eliminar nota: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeData = Theme.of(context).colorScheme;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteNote(context);
              onDelete();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Nota eliminada correctamente')),
              );
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotesScreen(
                    title: title,
                    description: description,
                    idNote: idNote,
                    isEditable: true,
                    priorityName: priorityName,
                  ),
                ),
              );
            },
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailsScreen(
                title: title,
                description: description,
                idNote: idNote,
                isEditable: false,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(30),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: themeData.secondary,
              child: Text(title[0], style: TextStyle(color: Colors.white)),
            ),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
