import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? masterPasswordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.userData['username']);
    emailController = TextEditingController(text: widget.userData['email']);
    masterPasswordController = TextEditingController(text: 'Password123'); // Valor "quemado"

    // Imprimir los datos recibidos
    print('Datos recibidos: ${widget.userData}');
  }

  @override
  void dispose() {
    usernameController?.dispose();
    emailController?.dispose();
    masterPasswordController?.dispose();
    super.dispose();
  }

  void _updateUserData() async {
    final token = context.read<TokenAuthProvider>().token;
    final userId = context.read<IdUserProvider>().idUser;

    if (token.isEmpty || userId.isEmpty) {
      print("No hay sesión activa");
      return;
    }

    final updatedData = {
      'username': usernameController?.text ?? '',
      'email': emailController?.text ?? '',
      'master_password': masterPasswordController?.text ?? '',
    };

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/users/update/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print("Datos actualizados correctamente");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados correctamente')),
        );
      } else {
        print("Error al actualizar los datos: ${response.statusCode}");
        print("Respuesta del servidor: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar los datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Perfil",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80, // Aumenta el tamaño del avatar
                backgroundImage: AssetImage(widget.userData['url_image']),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: usernameController,
              style: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
              decoration: InputDecoration(
                labelText: 'Usuario',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              style: TextStyle(fontSize: 18), // Aumenta el tamaño del texto
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              ),
            ),
            SizedBox(height: 50), // Aumenta el espacio antes del botón
            Center(
              child: ElevatedButton(
                onPressed: _updateUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Menos circular
                  ),
                ),
                child: Text('Actualizar Datos', style: TextStyle(fontSize: 18)), // Aumenta el tamaño del texto del botón
              ),
            ),
            SizedBox(height: 20), // Espacio antes del texto
            Center(
              child: Text(
                'Asegúrate que los datos ingresados sean correctos',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}