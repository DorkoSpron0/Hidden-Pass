import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/folder_model.dart';
import 'package:hidden_pass/DOMAIN/MODELS/password_options.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:provider/provider.dart';

class FolderForm extends StatefulWidget {
  const FolderForm({Key? key}) : super(key: key);

  @override
  State<FolderForm> createState() => _FolderFormState();
}

class _FolderFormState extends State<FolderForm> {
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordsController = TextEditingController();

  final FocusNode _folderNameFocus = FocusNode();
  final FocusNode _iconFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _passwordsFocus = FocusNode();

  void saveFolder(String name, String icon, String description, String passwords, BuildContext context) async {
    final Token = context.read<TokenAuthProvider>().token;
    final IdUser = context.read<IdUserProvider>().idUser;

    final Url = Uri.parse(
        'http://10.0.2.2:8081/api/v1/hidden_pass/folders/$IdUser');
    var Body = json.encode({
      "name": name,
      "icon": icon,
      "description": description,
      "passwords": passwords,
    });

    var response = await http.post(Url, body: Body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $Token'
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Carpeta creada con exito");
    } else {
      print("Error al crear la carpeta: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Nombre', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _folderNameController,
            focusNode: _folderNameFocus,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              hintText: 'Nombre de la carpeta',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color.fromARGB(255, 49, 49, 49),
            ),
          ),
          const Text('Descripcion', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              hintText: 'Ingresa una breve descripcion si deseas',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color.fromARGB(255, 49, 49, 49),
            ),
          ),
          
          const SizedBox(height: 16.0),
          const Text('Añadir contraseñas', style: TextStyle(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'select_folders');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Seleccionar Contraseñas', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 24.0),
          
          const SizedBox(height: 38),
          ElevatedButton(
            onPressed: () {
              String name = _folderNameController.text;
              String icon = _iconController.text;
              String description = _descriptionController.text;
              String passwords = _passwordsController.text;

              saveFolder(name, icon, description, passwords, context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PricipalPageScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}