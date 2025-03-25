import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void addNote(NoteModel note) async {
    final url = Uri.parse('falta el endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note), // Convertir NoteModel a JSON
      );

      if (response.statusCode == 201) {
        // La nota se creó con éxito
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotesListScreen(),
          ),
        ); 
      } else {
        // Manejar el error
        print('Error al crear la nota: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la nota')),
        );
      }
    } catch (e) {
      print('Error de red: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          double containerWidth = isSmallScreen ? constraints.maxWidth * 0.85 : constraints.maxWidth * 0.5;

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerWidth,
                        child: Text(
                          "Agregar nota",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Título',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(fontSize: 16 * 0.8, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: TextField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            labelText: 'Cuerpo',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          maxLines: null,
                          expands: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              // Flecha superior izquierda
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PricipalPageScreen(),
                      ),
                    ); 
                  },
                ),
              ),
              // Flecha inferior derecha
              Positioned(
                bottom: 40,
                right: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff323232),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      final note = NoteModel(
                        title: _titleController.text,
                        description: _bodyController.text,
                      );
                      addNote(note);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}