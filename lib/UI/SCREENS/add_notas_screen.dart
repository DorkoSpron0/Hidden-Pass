import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hidden_pass/main.dart';
import 'package:hive/hive.dart';
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

  late Box<NoteHiveObject> box;

  @override
  void initState() {
    super.initState();
    _openBox(); // Abre la caja al inicializar el widget
  }

  Future<void> _openBox() async {
    box = await Hive.openBox<NoteHiveObject>('notes');
  }


  void addNote(NoteModel note) async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;
    final url = Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/notes/$userId');


    if (token == null || token.isEmpty) {

      Future<bool> tituloExiste(String title) async {
        return box.values.any((note) => note.title == title);
      }

      try{

        Future<void> agregarObjetoUnico() async {
          if (!await tituloExiste(note.title)) {

            final newNote = NoteHiveObject(
                note.priorityName,
                note.title,
                note.description
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PricipalPageScreen(),
              ),
            );

            box.put(newNote.title, newNote);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El titulo debe ser único')),
            );
          }
        }

        agregarObjetoUnico();


      }catch(e){
        print(e.toString());
      }
    }else{
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
          SnackBar(content: Text('Ingresar solo la cantidad de carecteres permitidas: $e')),
        );
        print('Error: $e');
        print('token: $token');
      }
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

                            counterText: "", // agrego un contador de texto para saber cuantos caracteres tiene y puede ingresar

                          ),

                          maxLines: null,
                          expands: true,
                          maxLength: 255,

                          onChanged: (text){
                            setState(() {}); // esto refresca el widget y asi actualiza el contador
                          },

                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${_bodyController.text.length} / 255 caracteres', // Muestra la cantidad de caracteres
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
