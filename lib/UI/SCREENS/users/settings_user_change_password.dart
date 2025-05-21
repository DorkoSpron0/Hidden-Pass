import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';

class ChangeMasterPwdUserPage extends StatefulWidget {
  @override
  _ChangeMasterPwdUserPageState createState() => _ChangeMasterPwdUserPageState();
}

class _ChangeMasterPwdUserPageState extends State<ChangeMasterPwdUserPage> {
  final TextEditingController masterPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _isMasterPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void dispose() {
    masterPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void _toggleMasterPasswordVisibility() {
    setState(() {
      _isMasterPasswordVisible = !_isMasterPasswordVisible;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _updatePassword() async {
    final token = context.read<TokenAuthProvider>().token;
    final userId = context.read<IdUserProvider>().idUser;

    if (token.isEmpty || userId.isEmpty) {
      print("No hay sesión activa");
      return;
    }

    final masterPassword = masterPasswordController.text;
    final newPassword = newPasswordController.text;

    final passwordData = {
      'current_password': masterPassword,
      'new_password': newPassword,
    };

    try {
      final response = await http.put(
        Uri.parse(ApiConfig.endpoint("/users/update/password/$userId")),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(passwordData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("Contraseña actualizada correctamente");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actualizada correctamente')),
        );
      } else {
        print("Error al actualizar la contraseña: ${response.statusCode}");
        print("Respuesta del servidor: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La contraseña maestra no es válida')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la contraseña: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cambiar Contraseña',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: masterPasswordController,
                obscureText: !_isMasterPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Contraseña Maestra',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isMasterPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: _toggleMasterPasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: !_isNewPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: _toggleNewPasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(33, 33, 33, 1),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    'Actualizar Contraseña',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Revisa bien los datos ingresados, podrías perder acceso a tus datos.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}