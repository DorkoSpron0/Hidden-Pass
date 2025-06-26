import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  bool isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedPriority = 'BAJA';

  late Box<NoteHiveObject> box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    box = await Hive.openBox<NoteHiveObject>('notes');
  }

  void addNote(NoteModel note) async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;
    var url = Uri.parse(ApiConfig.endpoint("/notes/$userId"));

    setState(() {
      isLoading = true;
    });


    if (token == null || token.isEmpty) {
      Future<bool> tituloExiste(String title) async {
        return box.values.any((note) => note.title == title);
      }

      try {
        Future<void> agregarObjetoUnico() async {
          if (!await tituloExiste(note.title)) {
            final newNote = NoteHiveObject(
              note.priorityName,
              note.title,
              note.description,
            );
            box.put(newNote.title, newNote);

            Provider.of<DataListProvider>(context, listen: false).reloadPasswordList([]);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nota creada correctamente')),
            );


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PricipalPageScreen(),
              ),
            );

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El título debe ser único')),
            );
          }
        }

        agregarObjetoUnico();
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'priorityName': note.priorityName,
            'title': note.title,
            'description': note.description,
          }),
        );

        if (response.statusCode == 201) {

          //await Future.delayed(Duration(seconds: 10));

          Provider.of<DataListProvider>(context, listen: false).reloadNoteList([]);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nota creada correctamente')),
          );

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
          SnackBar(content: Text('Error: $e')),
        );
        print('Error: $e');
        print('token: $token');
      }finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80), 
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        child: TextField(
                          controller: _titleController,
                          style: TextStyle(color: colorScheme.tertiary),
                          decoration: InputDecoration(
                            labelText: 'Título',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelStyle: TextStyle(color: colorScheme.tertiary),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
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
                          style: TextStyle(color: colorScheme.tertiary),
                          decoration: InputDecoration(
                            labelText: 'Descripcion',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelStyle: TextStyle(color: colorScheme.tertiary),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
                            ),
                            counterText: "",
                          ),
                          maxLines: null,
                          expands: true,
                          maxLength: 255,
                          onChanged: (text) {
                            setState(() {});
                          },
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${_bodyController.text.length} / 255 caracteres',
                        style: TextStyle(
                          color: colorScheme.tertiary,
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
                                  color: colorScheme.tertiary,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Prioridad',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.tertiary,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.tertiary),
                            ),
                          ),
                          dropdownColor: colorScheme.primary,
                        ),
                      ),

                      isLoading ?
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              LoadingAnimationWidget.discreteCircle(
                                  size: 30, color: Theme.of(context).colorScheme.tertiary,
                                  secondRingColor: Theme.of(context).colorScheme.surface,
                                  thirdRingColor: Theme.of(context).colorScheme.secondary
                              ),
                              Text("Creando nota..."),
                            ],
                          ),
                        ),
                      ) : Text(""),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.arrow_back, color: colorScheme.tertiary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PricipalPageScreen(),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Agregar nota",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 22 : 26,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.tertiary,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
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

                    if (description != null && description != ""){
                      final note = NoteModel(
                      priorityName,
                      title,
                      description,
                    );

                    addNote(note);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Debes de agregar una descripcion')),
                      );
                    }
                    
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
