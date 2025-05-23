import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/SCREENS/users/settings_user_change_password.dart';
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
  String? _selectedAvatar;

  final List<String> _avatarImages = [
    'assets/images/LogoSimple.png',
    'assets/images/perro.png',
    'assets/images/zorro.png',
  ];

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.userData['username']);
    emailController = TextEditingController(text: widget.userData['email']);
    _selectedAvatar = widget.userData['url_image'];
  }

  @override
  void dispose() {
    usernameController?.dispose();
    emailController?.dispose();
    super.dispose();
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 350,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _avatarImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _selectAvatar(_avatarImages[index]),
                child: Image.asset(_avatarImages[index]),
              );
            },
          ),
        );
      },
    );
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
      'url_image': _selectedAvatar,
    };

    // Imprimir los datos que se van a enviar
    print("Datos a enviar: $updatedData");

    try {
      final response = await http.put(
        Uri.parse(ApiConfig.endpoint("/users/update/$userId")),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

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

  void _navigateToAnotherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeMasterPwdUserPage()),
    );
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
              child: GestureDetector(
                onTap: _showAvatarSelection,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(_selectedAvatar ?? 'assets/images/default.png'),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: usernameController,
              style: TextStyle(fontSize: 18),
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
              style: TextStyle(fontSize: 18),
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
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: _updateUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(33, 33, 33, 1), // Dark gray color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Actualizar Datos',
                  style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _navigateToAnotherScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(33, 33, 33, 1), // Dark gray color
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Actualizar contraseña',
                  style: TextStyle(fontSize: 15, color: Colors.red), // White text color
                ),
              ),
            ),
            SizedBox(height: 20),
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