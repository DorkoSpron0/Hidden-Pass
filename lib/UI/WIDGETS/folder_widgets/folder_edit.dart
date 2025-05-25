import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:provider/provider.dart';

class FolderEditForm extends StatefulWidget {
  final Map<String, dynamic> folder;
  const FolderEditForm({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderEditForm> createState() => _FolderEditFormState();
}

class _FolderEditFormState extends State<FolderEditForm> {
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedIcon = '';
  final List<String> _availableIcons = [
    'images/LogoSimple.png',
    'images/netflix.png',
    'images/perro.png',
    'images/zorro.png',
  ];

  List<Map<String, dynamic>> _passwordsList = [];
  List<String> _selectedPasswords = [];
  bool _loadingPasswords = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _folderNameController.text = widget.folder['name'] ?? '';
    _descriptionController.text = widget.folder['description'] ?? '';
    _selectedIcon = widget.folder['icon'] ?? 'images/LogoSimple.png';
    _loadPasswords();
  }

  Widget _buildFolderIcon(String iconPath, bool isSmallScreen) {
  return ClipOval(
    child: Image.asset(
      'assets/$iconPath',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.folder,
          size: double.infinity,
          color: Colors.white,
        );
      },
    ),
  );
}

  Future<void> _loadPasswords() async {
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
        final List<Map<String, dynamic>> allPasswords =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        final folderId = widget.folder['id_folder']?.toString();
        _selectedPasswords = allPasswords
            .where((password) => password['id_folder']?.toString() == folderId)
            .map((password) => password['id_password']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList();

        setState(() {
          _passwordsList = allPasswords;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar contraseñas: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loadingPasswords = false);
    }
  }

  Future<void> _editFolder() async {
    if (_folderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre de la carpeta es requerido')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      final token = context.read<TokenAuthProvider>().token.trim();
      final idUser = context.read<IdUserProvider>().idUser.trim();
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final selectedPasswordNames = _passwordsList
          .where((password) => _selectedPasswords.contains(password['id_password']?.toString()))
          .map((password) => password['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      final response = await http.put(
        Uri.parse(ApiConfig.endpoint("/folders/${widget.folder['id_folder']}")),
        body: json.encode({
          "name": _folderNameController.text.trim(),
          "icon": _selectedIcon.trim(),
          "description": _descriptionController.text.trim(),
          "passwords": selectedPasswordNames,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop(true);
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Error al actualizar carpeta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
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
                final iconPath = _availableIcons[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconPath;
                    });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: _selectedIcon == iconPath ? Colors.blue : null,
                    child: CircleAvatar(
                      radius: 28,
                      child: _buildFolderIcon(iconPath, false),
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isSmallScreen ? double.infinity : 600,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _showIconSelectionDialog,
                    child: Center(
                      child: CircleAvatar(
                        radius: isSmallScreen ? 40 : 50,
                        backgroundColor: Colors.grey[800],
                        child: _buildFolderIcon(_selectedIcon, isSmallScreen),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Nombre', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _folderNameController,
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
                      contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Descripción', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'Ingresa una breve descripción',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 49, 49, 49),
                      contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Añadir contraseñas',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    color: const Color.fromARGB(255, 49, 49, 49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: const Text('Seleccionar contraseñas',
                          style: TextStyle(color: Colors.white)),
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
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_passwordsList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No hay contraseñas disponibles',
                                style: TextStyle(color: Colors.white)),
                          )
                        else
                          ..._passwordsList.map((password) {
                            final passwordId = password['id_password']?.toString() ?? '';
                            return CheckboxListTile(
                              title: Text(password['name'] ?? 'Sin nombre',
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(password['username'] ?? '',
                                  style: const TextStyle(color: Colors.white70)),
                              value: _selectedPasswords.contains(passwordId),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedPasswords.add(passwordId);
                                  } else {
                                    _selectedPasswords.remove(passwordId);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 16,
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Contraseñas seleccionadas: ${_selectedPasswords.length}',
                    style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _editFolder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size.fromHeight(isSmallScreen ? 48 : 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Guardar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      minimumSize: Size.fromHeight(isSmallScreen ? 48 : 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
