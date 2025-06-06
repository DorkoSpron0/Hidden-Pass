import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/all_password_model.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/SCREENS/passwords/edit_password_screen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';

class PasswordListBodyWidget extends StatefulWidget {
  @override
  _PasswordListBodyWidgetState createState() => _PasswordListBodyWidgetState();
}

class _PasswordListBodyWidgetState extends State<PasswordListBodyWidget> {

  List<AllPasswordModel> passwordList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    passwordList = context.read<DataListProvider>().passwordList;
    final token = context.read<TokenAuthProvider>().token;
    if(passwordList.isEmpty){
      fetchPasswords(token);
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPasswords(String token) async {
    final idUser = context.read<IdUserProvider>().idUser;

    await Future.delayed(Duration(seconds: 5));

    if (token.isEmpty) {
      final box = Hive.box<PasswordHiveObject>('passwords');
      final passwords = box.values.toList();

      setState(() {
        passwordList = passwords.map((json) => AllPasswordModel(
            id_password: "",
            name: json.name,
            url: json.url,
            email_user: json.email_user,
            password: json.password,
            description: json.description
        )).toList();
      });
    } else {
      final url = Uri.parse(ApiConfig.endpoint("/passwords/$idUser"));

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final filteredPass = data.where((item)
        => item['id_folder'] == null || item['id_folder'].toString().isEmpty);

        setState(() {
          passwordList =
              filteredPass.map((json) => AllPasswordModel.fromJson(json)).toList();
        });

        isLoading = false;

        Provider.of<DataListProvider>(context, listen: false).reloadPasswordList(passwordList);
      } else {
        print("Failed to load passwords: ${response.statusCode}");
        isLoading = false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final token = context.read<TokenAuthProvider>().token;

    return

      isLoading ? Center(child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        color: Theme.of(context).colorScheme.secondary,
      )) :

      passwordList.isEmpty
        ? Center(child: Text("No tienes contraseñas guardadas"))
        : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
              onPressed: () => {
                setState(() {
                  passwordList = [];
                  isLoading = true;
                  fetchPasswords(token);
                })
              },
              icon: Icon(Icons.refresh)
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 5.0, bottom: 15.0), // 👈 separación visual arriba
              itemCount: passwordList.length,
              itemBuilder: (context, index) {
                final item = passwordList[index];
                return Slidable(
                  key: Key(item.id_password),
                  endActionPane: ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        deletePassword(context, item.id_password, item.name, token);
                        // Quita esta línea:
                        // setState(() {
                        //   passwordList.removeAt(index);
                        // });
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        editPassword(context, item.id_password, item.name, item.description, item.url,
                            item.email_user, item.password);
                      },
                      icon: Icons.edit,
                      backgroundColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ]),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(20),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Text(item.name[0], style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(item.email_user, style: Theme.of(context).textTheme.bodySmall),
                      trailing: IconButton(
                        icon: Icon(Icons.copy, color: Colors.grey),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Contraseña copiada al portapapeles')),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
  }

  void editPassword(BuildContext context, String id, String name, String descripcion,
      String url, String emailUser, String password) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPasswordScreen(
              id_password: id,
              nombre: name,
              description: descripcion,
              email_user: emailUser,
              password: password,
              url: url,
            )));
  }

  void deletePassword(BuildContext context, String id, String name, String token) async {
    if (token.isNotEmpty) {
      try {
        final url = Uri.parse(ApiConfig.endpoint("/passwords/password/$id"));

        final response = await http.delete(url, headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contraseña eliminada del servidor correctamente')),
            );
            setState(() {
              passwordList.removeWhere((item) => item.id_password == id);
            });
          }

          Provider.of<DataListProvider>(context, listen: false).reloadPasswordList([]);

        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar la contraseña del servidor: ${response.statusCode}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la contraseña: $e')),
          );
        }
      }
    } else {
      final box = Hive.box<PasswordHiveObject>('passwords');

      Future<bool> tituloExiste(String name) async {
        return box.values.any((password) => password.name == name);
      }

      if (await tituloExiste(name) == true) {
        box.delete(name);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña eliminada del servidor correctamente')),
        );
        setState(() {
          passwordList.removeWhere((item) => item.name == name);
        });
      }
    }
  }
}