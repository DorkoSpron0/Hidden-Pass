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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // Quita el focus de cualquier campo activo
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Editar contraseña'),
          titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
        ),
        body: Center(
          child: EditPasswordWidget(
            nombre: nombre,
            description: description,
            email_user: email_user,
            password: password,
            url: url,
            id: id_password,
          ),
        ),
      ),
    );
  }
}
