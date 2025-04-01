import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/edit_notes_screen.dart';
import 'package:hidden_pass/UI/SCREENS/see_notes_screen.dart';
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
  NoteItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.idNote, 
    required this.priorityName, 
  });

  // Función para eliminar la nota
  void deleteNote(BuildContext context) async {
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      // hive de nicky
      print("Nota eliminada localmente: $idNote");
      
    } else {
      final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/$idNote');

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
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
         
          SlidableAction(
            onPressed: (context) {
              deleteNote(context);
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
          Navigator.push(context,
           MaterialPageRoute(builder: (context)=> NoteDetailsScreen(title: title, description: description, idNote: idNote, isEditable: false, ))
           );
          
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(80),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
