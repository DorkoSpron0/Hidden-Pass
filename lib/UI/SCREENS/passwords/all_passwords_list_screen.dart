import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';

import '../../WIDGETS/password_list_widgets/all_passwords_list.dart';


void main() => runApp(const PasswordListScreen());

class PasswordListScreen extends StatelessWidget {
  const PasswordListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crear contraseñas',
      theme: customThemeData(isDarkMode: true),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton( // Agrega el IconButton aquí
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla (Supongo menu?)anterior
            },
          ),
          title: const Text('Tus Contraseñas'),
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          actions: <Widget>[],
        ),
        body: Center( 
          child: PasswordListWidget(),
        ),
      ),
    );
  }
}