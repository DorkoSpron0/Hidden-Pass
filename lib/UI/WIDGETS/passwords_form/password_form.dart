import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/password_options.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:provider/provider.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  PasswordOptions options = PasswordOptions();
  bool _showPassword = false;
  String _generatedPassword = '';
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _accountNameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  late Box<PasswordHiveObject> box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    box = await Hive.openBox<PasswordHiveObject>('passwords');
  }

  void savePassword(String name, String url, String email_user, String password,
      String description, BuildContext context) async {
    final Token = context.read<TokenAuthProvider>().token;
    final IdUser = context.read<IdUserProvider>().idUser;

    if (Token.isEmpty) {
      Future<bool> tituloExiste(String name) async {
        return box.values.any((password) => password.name == name);
      }

      try {
        Future<void> agregarObjetoUnico() async {
          if (!await tituloExiste(name)) {
            final newPassword = PasswordHiveObject(
                name: name,
                description: description,
                email_user: email_user,
                password: password,
                url: url);

            await box.put(newPassword.name, newPassword);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PricipalPageScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El titulo debe ser único')),
            );
          }
        }

        await agregarObjetoUnico();
      } catch (e) {
        print(e.toString());
      }
    } else {
      final Url = Uri.parse(ApiConfig.endpoint("/passwords/$IdUser"));

      var Body = json.encode({
        "name": name,
        "url": url,
        "email_user": email_user,
        "password": password,
        "description": description,
      });

      var response = await http.post(Url, body: Body, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $Token'
      });
      print("Body enviado: $Body");
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Contraseña guardada correctamente");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PricipalPageScreen(),
          ),
        );
      } else {
        print("Error al guardar la contraseña: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la contraseña')),
        );
      }
    }
  }

  void _onSavePressed() {
    final name = _accountNameController.text.trim();
    final url = _urlController.text.trim();
    final email_user = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final description = _descriptionController.text.trim();

    savePassword(name, url, email_user, password, description, context);
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Nombre', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _accountNameController,
            focusNode: _accountNameFocus,
            style: TextStyle(color: colorScheme.onSurface), // texto del input
            decoration: InputDecoration(
              hintText: 'Nombre de la cuenta',
              hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              filled: true,
              fillColor: colorScheme.surface, // fondo del input

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline), // contorno
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.secondary, width: 2),
              ),
            ),
          ),
          const Text('Descripcion', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
              style: TextStyle(color: colorScheme.onSurface), // texto del input
              decoration: InputDecoration(

                hintText: 'Ingresa una breve descripcion',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: colorScheme.surface, // fondo del input

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline), // contorno
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                ),
              )
          ),
          const Text('Sitio web', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _urlController,
            focusNode: _urlFocus,
              style: TextStyle(color: colorScheme.onSurface), // texto del input
              decoration: InputDecoration(

                hintText: 'Ingresa el URL de la pagina',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: colorScheme.surface, // fondo del input

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline), // contorno
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                ),
              )
          ),
          const SizedBox(height: 16.0),
          const Text('Email', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _emailController,
            focusNode: _emailFocus,
              style: TextStyle(color: colorScheme.onSurface), // texto del input
              decoration: InputDecoration(

                hintText: 'tucorreo@gmail.com',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: colorScheme.surface, // fondo del input

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline), // contorno
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                ),
              )
          ),
          const SizedBox(height: 24.0),
          Text('Contraseña',
              style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  obscureText: !_showPassword,
                  controller: _passwordController,
                    style: TextStyle(color: colorScheme.onSurface), // texto del input
                    decoration: InputDecoration(

                      hintText: 'GhYjmJUynNJ.Mhn',
                      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                      filled: true,
                      fillColor: colorScheme.surface, // fondo del input

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outline), // contorno
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                      ),
                    )
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
                Text('Numeros', style: TextStyle(color: colorScheme.secondary)),
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
                Text('Simbolos  ', style: TextStyle(color: colorScheme.secondary)),
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
                Text('Minúsculas', style: TextStyle(color: colorScheme.secondary)),
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
                Text('Mayúscula', style: TextStyle(color: colorScheme.secondary)),
              ]),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _generatedPassword = generatePassword(options);
                _passwordController.text = _generatedPassword;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              minimumSize: const Size.fromHeight(45),
            ),
            child: Text('Generar contraseña',
                style: TextStyle(color: colorScheme.primary)),
          ),
          const SizedBox(height: 38),
          ElevatedButton(
            onPressed: _onSavePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
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
