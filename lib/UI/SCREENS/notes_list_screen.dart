import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<NoteModel> notesList = [];

  // Método para obtener las notas desde la API
  Future<void> fetchNotes() async {
    final url = Uri.parse('tu_api_url_aqui'); // Cambia esto por tu URL de la API

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // setState(() {
        //   notesList = data.map((json) {
        //     return NoteModel(
        //       id_priority: json['id'],
        //       title: json['title'],
        //       description: json['description'],
        //     );
        //   }).toList();
        // });
      } else {
        throw Exception('Error al cargar las notas');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotes(); // Llama a la API cuando la pantalla se carga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notesList.isEmpty
          ? Center(child: CircularProgressIndicator()) // este es el loader para esperar la carga de las contraseñ
          : ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navegar a una pantalla de detalles (asegúrate de que NoteDetailsScreen esté definido)
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailsScreen(note: notesList[index])));
                  },
                  child: ListTile(
                    title: Text(notesList[index].title),
                    subtitle: Text(notesList[index].description),
                  ),
                );
              },
            ),
    );
  }
}
