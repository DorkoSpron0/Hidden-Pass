import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/passwords_form/password_form.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart'; 

void main() => runApp(const AllPasswordsListScreen());

class AllPasswordsListScreen extends StatelessWidget {
  const AllPasswordsListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crear contraseñas',
      theme: customThemeData(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton( // Agrega el IconButton aquí
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla (Supongo menu?)anterior
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
        body: const Center( 
          child: PasswordForm(),
        ),
      ),
    );
  }
}