import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hidden_pass/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedPriority = 'BAJA'; 

  void addNote(NoteModel note) async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;
    final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/$userId');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debe de estar logueado para poder realizar este proceso')),
      );
      return;
    }
    try {
     
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'priorityName': note.priorityName, 
          'title': note.title,
          'description': note.description,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}"); 
      print(response.statusCode);

      if (response.statusCode == 200) {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PricipalPageScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la nota: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('en el proceso: $e')),
      );
      print('Error: $e');
      print('token: $token');
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
                          style: TextStyle(color: Colors.white),
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
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: TextField(
                          controller: _bodyController,
                          style: TextStyle(color: Colors.white), 
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
                          maxLines: null,
                          expands: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPriority = newValue!;
                            });
                          },
                          items: ['BAJA', 'MEDIA', 'ALTA', 'CRITICA']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,  
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white, 
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Prioridad',  
                            labelStyle: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.white, 
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), 
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), 
                            ),
                          ),
                          dropdownColor: const Color.fromARGB(255, 53, 53, 53), 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.arrow_back),
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
              Positioned(
                bottom: 40,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    String priorityName = _selectedPriority;
                    String title = _titleController.text;
                    String description = _bodyController.text;

                    final note = NoteModel(
                      priorityName,
                      title,
                      description,
                    );

                    addNote(note);
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
