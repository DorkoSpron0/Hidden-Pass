import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/WIDGETS/passwords_form/password_form.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';
import 'package:provider/provider.dart';

void main() => runApp(const CreateNewPasswordScreen());

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crear contraseñas',
      theme: customThemeData(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Nueva contraseña'),
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("Guardar presionado");
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
              child: const Text("Guardar"),
            ),
          ],
        ),
        body: SingleChildScrollView( // Cambiado aquí
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Añadir padding si es necesario
            child: Column(
              children: const [
                PasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}