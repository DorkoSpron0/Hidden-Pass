import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/password_options.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditPasswordWidget extends StatefulWidget {
  final String id;
  final String nombre;
  final String description;
  final String email_user;
  final String password;
  final String url;

  const EditPasswordWidget({
    Key? key,
    required this.nombre,
    required this.description,
    required this.email_user,
    required this.password,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<EditPasswordWidget> {
  PasswordOptions options = PasswordOptions();
  bool _showPassword = false;
  String _generatedPassword = '';
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _accountNameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _accountNameController.text = widget.nombre;
    _descriptionController.text = widget.description;
    _urlController.text = widget.url;
    _emailController.text = widget.email_user;
    _generatedPassword = widget.password;
  }

  @override
  void dispose() {
    _accountNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void savePassword(String name, String url, String email_user, String password,
      String description, BuildContext context) async {
    final Token = context.read<TokenAuthProvider>().token;
    final id = widget.id;

    final box = Hive.box<PasswordHiveObject>('passwords');

    if (Token.isEmpty) {
      Future<bool> tituloExiste(String name) async {
        return box.values.any((password) => password.name == name);
      }

      if (await tituloExiste(widget.nombre)) {
        box.delete(widget.nombre);

        PasswordHiveObject newPassword = PasswordHiveObject(
            name: name,
            url: url,
            password: password,
            email_user: email_user,
            description: description);

        box.put(name, newPassword);
      }

      print("Guardar contraseña localmente");
      return;
    } else {
      final Url = Uri.parse(
          'http://10.0.2.2:8081/api/v1/hidden_pass/passwords/password/$id');
      var Body = json.encode({
        "name": name,
        "url": url,
        "email_user": email_user,
        "password": password,
        "description": description,
      });

      var response = await http.put(Url, body: Body, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $Token'
      });

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Contraseña guardada correctamente");
      } else {
        print("Error al guardar la contraseña: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Envolver en SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Nombre', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _accountNameController,
              focusNode: _accountNameFocusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: 'Nombre de la cuenta',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 49, 49, 49),
              ),
            ),
            const Text('Descripcion', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: 'Ingresa una breve descripcion',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 49, 49, 49),
              ),
            ),
            const Text('Sitio web', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: 'Ingresa el URL de la pagina',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 49, 49, 49),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Email', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: 'tucorreo@gmail.com',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 49, 49, 49),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text('Contraseña',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: !_showPassword,
                    controller: TextEditingController(text: _generatedPassword),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'GhYjmJUynNJ.Mhn',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 49, 49, 49),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Caracteres', style: TextStyle(color: Colors.white)),
            Slider(
              value: options.length.toDouble(),
              min: 8,
              max: 30,
              divisions: 22,
              label: options.length.toString(),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              onChanged: (double value) {
                setState(() {
                  options.length = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Checkbox(
                    value: options.includeNumbers,
                    onChanged: (bool? value) {
                      setState(() {
                        options.includeNumbers = value!;
                      });
                    },
                  ),
                  const Text('Numeros', style: TextStyle(color: Colors.white)),
                ]),
                Row(children: [
                  Checkbox(
                    value: options.includeSymbols,
                    onChanged: (bool? value) {
                      setState(() {
                        options.includeSymbols = value!;
                      });
                    },
                  ),
                  const Text('Simbolos  ', style: TextStyle(color: Colors.white)),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Checkbox(
                    value: options.includeLowercase,
                    onChanged: (bool? value) {
                      setState(() {
                        options.includeLowercase = value!;
                      });
                    },
                  ),
                  const Text('Minúsculas', style: TextStyle(color: Colors.white)),
                ]),
                Row(children: [
                  Checkbox(
                    value: options.includeUppercase,
                    onChanged: (bool? value) {
                      setState(() {
                        options.includeUppercase = value!;
                      });
                    },
                  ),
                  const Text('Mayúscula', style: TextStyle(color: Colors.white)),
                ]),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _generatedPassword = generatePassword(options);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white12,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text('Generar contraseña',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 38),
            ElevatedButton(
              onPressed: () {
                String name = _accountNameController.text;
                String url = _urlController.text;
                String email_user = _emailController.text;
                String password = _generatedPassword;
                String description = _descriptionController.text;

                savePassword(
                    name, url, email_user, password, description, context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PricipalPageScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String generatePassword(PasswordOptions options) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (options.includeLowercase) chars += lowercase;
    if (options.includeUppercase) chars += uppercase;
    if (options.includeNumbers) chars += numbers;
    if (options.includeSymbols) chars += symbols;

    if (chars.isEmpty) return '';

    return List.generate(options.length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}