import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/WIDGETS/notes_widgets/note_item_widget.dart';
import 'package:hive/hive.dart';
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

  // se asigna un valor a cada prioridad para asi poderle dar un orden a la lista
  int prioridadValor(String prioridad) {
    switch (prioridad.toUpperCase()) {
      case 'CRITICA':
        return 4;
      case 'ALTA':
        return 3;
      case 'MEDIA':
        return 2;
      case 'BAJA':
        return 1;
      default:
        return 0;
    }
  }

  void Notes() async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      final box = Hive.box<NoteHiveObject>('notes');
      final notas = box.values.toList();

      setState(() {
        notesList = notas.map((noteData) {
          return {
            'priorityName': noteData.priorityName ?? '',
            'title': noteData.title.toString(),
            'description': noteData.description.toString(),
          };
        }).toList();

        // Ordenar por prioridad
        notesList.sort((a, b) => prioridadValor(b['priorityName']!)
            .compareTo(prioridadValor(a['priorityName']!)));

        isLoading = false;
      });
    } else {
      var url = Uri.parse(ApiConfig.endpoint("/notes/$userId"));

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

            // Ordenar por prioridad
            notesList.sort((a, b) => prioridadValor(b['priorityName']!)
                .compareTo(prioridadValor(a['priorityName']!)));

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
                      idNote: note['id_note']?.toString() ?? '',
                      priorityName: note['priorityName'] as String,
                      onDelete: () {
                        setState(() {
                          notesList.removeAt(index);
                        });
                      },
                    );
                  },
                ),
      backgroundColor: Colors.grey.shade900,
    );
  }
}
