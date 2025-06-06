import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
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
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedIcon = 'images/LogoSimple.png';
  final List<String> _availableIcons = [
    'images/dinsey.png',
    'images/netflix.png',
    'images/perro.png',
    'images/zorro.png',
  ];

  List<Map<String, dynamic>> _passwordsList = [];
  List<String> _selectedPasswordNames = [];
  bool _loadingPasswords = false;

  @override
  void initState() {
    super.initState();
    _RecargarPasswords();
  }

  void saveFolder(String name, String icon, String description, BuildContext context) async {
    final token = context.read<TokenAuthProvider>().token.trim();
    final idUser = context.read<IdUserProvider>().idUser.trim();
    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

    try {
      print("passwords ${_selectedPasswordNames.map((n) => n.replaceAll(' ', '')).toList()}");
      var response = await http.post(
        Uri.parse(ApiConfig.endpoint("/folders/$idUser")),
        body: json.encode({
          "name": name.trim(),
          "icon": icon.trim(),
          "description": description.trim(),
          "passwords": _selectedPasswordNames.map((n) => n.trim()).toList(),
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PricipalPageScreen()),
        );
      } else {
        print('Error al guardar carpeta: ${response.statusCode}');
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al guardar carpeta: $e');
    }
  }

  Future<void> _RecargarPasswords() async {
    setState(() => _loadingPasswords = true);

    try {
      final token = context.read<TokenAuthProvider>().token.trim();
      final idUser = context.read<IdUserProvider>().idUser.trim();
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final url = Uri.parse(ApiConfig.endpoint("/passwords/$idUser"));

      final response = await http.get(
        url,
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _passwordsList = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
        });
      } else {
        print('Failed to load passwords: ${response.statusCode}');
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al cargar contraseñas: $e');
    } finally {
      setState(() => _loadingPasswords = false);
    }
  }

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Icono'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = _availableIcons[index];
                    });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/${_availableIcons[index]}',
                        width: 80, 
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: _showIconSelectionDialog,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/$_selectedIcon'),
                child: _selectedIcon == 'default_icon.png'
                    ? const Icon(Icons.add, size: 40, color: Colors.white)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Nombre', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          TextField(
            controller: _folderNameController,
            style: TextStyle(color: colorScheme.onSurface), // texto del input
            decoration: InputDecoration(
              hintText: 'Nombre de la cuenta',
              hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              filled: true,
              fillColor: colorScheme.surface, // fondo del input

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline), // contorno
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.secondary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Descripción', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: TextStyle(color: colorScheme.onSurface), // texto del input
            decoration: InputDecoration(
              hintText: 'Nombre de la cuenta',
              hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              filled: true,
              fillColor: colorScheme.surface, // fondo del input

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline), // contorno
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.secondary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text('Añadir contraseñas',
              style: TextStyle(
                  color: colorScheme.tertiary, fontSize: 16, fontWeight: FontWeight.bold)),
          Card(
            color: colorScheme.surface,
            child: ExpansionTile(
              title: Text('Seleccionar contraseñas',
                  style: TextStyle(color: colorScheme.secondary)),
              trailing: _loadingPasswords
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              children: [
                if (_loadingPasswords)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  )
                else if (_passwordsList.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No hay contraseñas disponibles',
                        style: TextStyle(color: colorScheme.secondary)),
                  )
                else
                  ..._passwordsList.map((password) {
                    String passwordName = password['name'] ?? 'SinNombre';
                    return CheckboxListTile(
                      title: Text(passwordName,
                          style: TextStyle(color: colorScheme.secondary)),
                      subtitle: Text(password['username'] ?? '',
                          style: TextStyle(color: colorScheme.secondary)),
                      value: _selectedPasswordNames.contains(passwordName),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedPasswordNames.add(passwordName);
                          } else {
                            _selectedPasswordNames.remove(passwordName);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  })
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Contraseñas seleccionadas: ${_selectedPasswordNames.length}',
            style: TextStyle(color: colorScheme.tertiary),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              String name = _folderNameController.text;
              String description = _descriptionController.text;
              saveFolder(name, _selectedIcon, description, context);
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
