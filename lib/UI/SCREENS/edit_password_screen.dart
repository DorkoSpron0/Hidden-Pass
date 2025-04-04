import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';
import 'package:hidden_pass/UI/WIDGETS/passwords_form/edit_password_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/passwords_form/password_form.dart';

class EditPasswordScreen extends StatelessWidget {
  final String id_password;
  final String nombre;
  final String description;
  final String email_user;
  final String password;
  final String url;

  const EditPasswordScreen(
      {super.key,
      required this.nombre,
      required this.description,
      required this.email_user,
      required this.password,
      required this.url,
      required this.id_password});

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
              Navigator.pop(
                  context); // Regresa a la pantalla (Supongo menu?)anterior
            },
          ),
          title: const Text('Editar contraseña'),
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
        body: Center(
          child: EditPasswordWidget(
              nombre: nombre,
              description: description,
              email_user: email_user,
              password: password,
              url: url,
              id: id_password),
        ),
      ),
    );
  }
}
