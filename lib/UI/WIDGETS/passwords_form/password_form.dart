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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  List<Map<String, dynamic>> folders = [];
  String? _selectedFolderName;
  bool isLoading = false;
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
  final FocusNode _passwordFocus = FocusNode();

  late Box<PasswordHiveObject> box;

  // Método para verificar si hay al menos un checkbox seleccionado
  bool get _canGeneratePassword {
    return options.includeLowercase ||
        options.includeUppercase ||
        options.includeNumbers ||
        options.includeSymbols;
  }

  // verificar si hay al menos un campo con texto, para el guardar
  bool get _canSave {
    return _accountNameController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _urlController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _openBox();
    loadingFolders();

    _accountNameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _urlController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accountNameFocus.dispose();
    _descriptionFocus.dispose();
    _urlFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _accountNameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> loadingFolders() async {
    final token = context.read<TokenAuthProvider>().token.trim();
    final idUser = context.read<IdUserProvider>().idUser.trim();

    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.endpoint("/folders/$idUser")),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Respuesta del cuerpo del folder ${response.body}");
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          folders = data.cast<Map<String, dynamic>>();
          if (folders.isNotEmpty) {
            _selectedFolderName = folders.first['name'].toString();
          }
          debugPrint('Datos recibidos: $data');
        });
      } else {
        debugPrint('Error al cargar folders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al cargar folders: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _openBox() async {
    box = await Hive.openBox<PasswordHiveObject>('passwords');
  }

  void savePassword(String name, String url, String email_user, String password,
      String description, String? name_folder, BuildContext context) async {
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
              url: url,
            );

            await box.put(newPassword.name, newPassword);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PricipalPageScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El título debe ser único')),
            );
          }
        }

        await agregarObjetoUnico();
      } catch (e) {
        print(e.toString());
      }
    } else {
      final Url = Uri.parse(ApiConfig.endpoint("/passwords/$IdUser"));

      setState(() {
        isLoading = true;
      });

      var Body = json.encode({
        "name": name,
        "url": url,
        "email_user": email_user,
        "password": password,
        "description": description,
        "folder_name": name_folder,
      });

      print("Body a enviar: $Body");
      print("El nombre del folder es: $name_folder");
      print(
          "Este es el valor enviado************************************* ${name_folder == null ? 'NULL REAL' : name_folder}");

      try {
        var response = await http.post(Url, body: Body, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $Token'
        });

        print("Respuesta del servidor: ${response.body}");
        print("Status code: ${response.statusCode}");

        if (response.statusCode == 201) {
          print("Contraseña guardada correctamente!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PricipalPageScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error al guardar la contraseña: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print("Error en la petición: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _onSavePressed() {
    // Validación del campo nombre
    if (_accountNameController.text.trim().isEmpty) {
      _showSnackBar('El nombre no debe estar vacío');
      return;
    }

    if (!_canSave) {
      _showSnackBar('Todos los campos están vacíos, ingresa los datos de la cuenta para continuar.');
      return;
    }

    final name = _accountNameController.text.trim();
    final url = _urlController.text.trim();
    final email_user = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final description = _descriptionController.text.trim();

    savePassword(name, url, email_user, password, description,
        _selectedFolderName, context);
  }

  void _onGeneratePasswordPressed() {
    if (!_canGeneratePassword) {
      _showSnackBar('Selecciona al menos una opción para generar contraseña');
      return;
    }

    setState(() {
      _generatedPassword = generatePassword(options);
      _passwordController.text = _generatedPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    const Text('Nombre*', style: TextStyle(color: Colors.white)),
    TextField(
    controller: _accountNameController,
    focusNode: _accountNameFocus,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
    hintText: 'Nombre plataforma',
    hintStyle:
    TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide:
    BorderSide(color: colorScheme.secondary, width: 2),
    ),
    ),
    ),
    const SizedBox(height: 16),
    const Text('Descripción', style: TextStyle(color: Colors.white)),
    TextField(
    controller: _descriptionController,
    focusNode: _descriptionFocus,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
    hintText: 'Ingresa una breve descripción',
    hintStyle: TextStyle(
    color: colorScheme.onSurface.withOpacity(0.6)),
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide:
    BorderSide(color: colorScheme.secondary, width: 2),
    ),
    )),
    const SizedBox(height: 16),
    const Text('Sitio web', style: TextStyle(color: Colors.white)),
    TextField(
    controller: _urlController,
    focusNode: _urlFocus,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
    hintText: 'Ingresa el URL de la página',
    hintStyle: TextStyle(
    color: colorScheme.onSurface.withOpacity(0.6)),
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide:
    BorderSide(color: colorScheme.secondary, width: 2),
    ),
    )),
    const SizedBox(height: 16),
    const Text('Correo electrónico',
    style: TextStyle(color: Colors.white)),
    TextField(
    controller: _emailController,
    focusNode: _emailFocus,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
    hintText: 'tucorreo@gmail.com',
    hintStyle: TextStyle(
    color: colorScheme.onSurface.withOpacity(0.6)),
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide:
    BorderSide(color: colorScheme.secondary, width: 2),
    ),
    )),
    const SizedBox(height: 24),
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
    focusNode: _passwordFocus,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
    hintText: 'GhYjmJUynNJ.Mhn',
    hintStyle: TextStyle(
    color: colorScheme.onSurface.withOpacity(0.6)),
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
    color: colorScheme.secondary, width: 2),
    ),
    )),
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
      Text('Selecciona una carpeta',
          style: TextStyle(color: colorScheme.secondary, fontSize: 16)),
      DropdownButtonFormField<String>(
        value: _selectedFolderName,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('Sin carpeta'),
          ),
          ...folders.map<DropdownMenuItem<String>>((folder) {
            return DropdownMenuItem<String>(
              value: folder['name'].toString(),
              child: Text(folder['name'] ?? 'Sin nombre'),
            );
          }).toList(),
        ],
        onChanged: (String? newValue) {
          setState(() {
            _selectedFolderName = newValue;
          });
        },
        validator: (value) => null,
      ),
      const SizedBox(height: 16),
      const Text('Carácteres', style: TextStyle(color: Colors.white)),
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
            Text('Números',
                style: TextStyle(color: colorScheme.secondary)),
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
            Text('Símbolos  ',
                style: TextStyle(color: colorScheme.secondary)),
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
            Text('Minúsculas',
                style: TextStyle(color: colorScheme.secondary)),
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
            Text('Mayúsculas',
                style: TextStyle(color: colorScheme.secondary)),
          ]),
        ],
      ),
      ElevatedButton(
        onPressed: _onGeneratePasswordPressed,
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
        child: const Text('Guardar',
            style: TextStyle(color: Colors.white)),
      ),
      isLoading
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              LoadingAnimationWidget.discreteCircle(
                  size: 30,
                  color: Theme.of(context).colorScheme.tertiary,
                  secondRingColor:
                  Theme.of(context).colorScheme.surface,
                  thirdRingColor:
                  Theme.of(context).colorScheme.secondary),
              Text("Creando contraseña..."),
            ],
          ),
        ),
      )
          : const SizedBox(),
    ],
    ),
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