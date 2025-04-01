import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/WIDGETS/notes_widgets/note_item_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Map<String, dynamic>> notesList = [];
  bool isLoading = true;

  void Notes() async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      // Si no hay token, no hacemos nada, o esperamos para Hive de nicky
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/$userId');

      try {
        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            notesList = data.map((noteData) {
              return {
                'priorityName': noteData['priorityName']?.toString() ?? '',
                'id_note': noteData['id_note'],
                'title': noteData['title']?.toString() ?? '',
                'description': noteData['description']?.toString() ?? '',
              };
            }).toList();
            isLoading = false;
          });
        } else {
          print('Error al cargar las notas: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error de conexión o al procesar la respuesta: $e');
        setState(() {
          isLoading = false;
        });
        
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Notes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notesList.isEmpty
              ? Center(child: Text('No tienes notas guardadas'))
              : ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    final note = notesList[index];
                    return NoteItemWidget(
                      title: note['title'] as String,
                      description: note['description'] as String,
                      idNote: note['id_note'].toString(),
                      priorityName: note['priorityName'] as String,
                    );
                  },
                ),
      backgroundColor: Colors.grey.shade900,
    );
  }
}