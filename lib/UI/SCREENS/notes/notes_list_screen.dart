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

import '../../PROVIDERS/password_list_provider.dart';

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

    await Future.delayed(Duration(seconds: 2));

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
          final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

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

          Provider.of<DataListProvider>(context, listen: false).reloadNoteList(notesList);
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
    notesList = context.read<DataListProvider>().notesList;
    if(notesList.isEmpty){
      Notes();
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: IconButton(
                  onPressed: () => {
                    setState(() {
                      isLoading  = true;
                      notesList = [];
                      Notes();
                    })
                  },
                  icon: Icon(Icons.refresh)
              ),
            ),
          ),
          Expanded(child: isLoading
              ? Center(child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            color: Theme.of(context).colorScheme.secondary,
          ))
              : notesList.isEmpty
              ? Center(child: Text('No tienes notas guardadas'))
              : ListView.builder(
            padding: const EdgeInsets.only(top: 12.0, bottom: 16.0), // 👈 separación visual arriba
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
          )
        ],
      )
    );
  }
}
