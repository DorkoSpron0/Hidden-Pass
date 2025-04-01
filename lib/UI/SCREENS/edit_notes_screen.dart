import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class EditNotesScreen extends StatefulWidget {
  final String title;
  final String description;
  final String priorityName;
  final String idNote;
  final bool isEditable;

  EditNotesScreen({
    required this.title,
    required this.description,
    required this.idNote,
    required this.isEditable,
    required this.priorityName,
  });

  @override
  _EditNotesScreenState createState() => _EditNotesScreenState();
}

class _EditNotesScreenState extends State<EditNotesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? _selectedPriority; 

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _bodyController.text = widget.description;

    if (<String>['BAJA', 'MEDIA', 'ALTA', 'CRITICA'].contains(widget.priorityName)) {
      _selectedPriority = widget.priorityName;
    } else {
      _selectedPriority = null; 
      
    }
  }

  void EditNote(BuildContext context) async {
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token no disponible')));
      return;
    }

    final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/${widget.idNote}');
    try {
      var body = json.encode({
        'priorityName': _selectedPriority,
        'title': _titleController.text,
        'description': _bodyController.text
      });

      final response = await http.put(
        url,
        body: body,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PricipalPageScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar la nota: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                          "Editar nota",
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
                            counterText: "",
                          ),
                          maxLines: null,
                          expands: true,
                          maxLength: 255,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${_bodyController.text.length} / 255 caracteres',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPriority = newValue;
                            });
                          },
                          items: const <String>['BAJA', 'MEDIA', 'ALTA', 'CRITICA']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
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
                  icon: const Icon(Icons.arrow_back),
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
                    if (_selectedPriority != null) {
                      EditNote(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, selecciona una prioridad')),
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}