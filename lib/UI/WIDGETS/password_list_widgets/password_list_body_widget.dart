import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hidden_pass/DOMAIN/MODELS/all_password_model.dart';
import 'package:hidden_pass/UI/SCREENS/edit_password_screen.dart';
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

  @override
  void initState() {
    super.initState();
    fetchPasswords();
  }

  Future<void> fetchPasswords() async {
    final token = context.read<TokenAuthProvider>().token;
    final idUser = context.read<IdUserProvider>().idUser;

    if (token == null || token.isEmpty) {
      // Si no hay token, no hacemos nada, o esperamos para Hive de nicky
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
      final url = Uri.parse(
          'http://10.0.2.2:8081/api/v1/hidden_pass/passwords/$idUser');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          passwordList =
              data.map((json) => AllPasswordModel.fromJson(json)).toList();
        });
      } else {
        print("Failed to load passwords: ${response.statusCode}");
      }
    }
  }
  //me quiero cortar una gueva xd

  @override
  Widget build(BuildContext context) {
    return passwordList.isEmpty ? Center(child: Text("No tienes contraseñas guardadas")) :

        ListView.builder(
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
      final item = passwordList[index];
      return Slidable(
        key: Key(item.id_password),
        endActionPane: ActionPane(motion: const DrawerMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              deletePassword(context, item.id_password, item.name);

              setState(() {
                passwordList.removeAt(index);
              });

            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          SlidableAction(
            onPressed: (context) {
              editPassword(context, item.id_password,item.name, item.description, item.url,
                  item.email_user, item.password);
            },
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ]),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(item.name[0], style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          title:
          Text(item.name, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(item.email_user,
              style: Theme.of(context).textTheme.bodySmall),
          trailing: IconButton(
            icon: Icon(Icons.copy, color: Colors.grey),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contraseña copiada al portapapeles')),
              );
            },
          ),
        ),
      );
    },
    );
  }

  Widget slideRightBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20),
            Icon(Icons.edit, color: Colors.white),
            Text(
              " Editar",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.error,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text(
              " Eliminar",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  void editPassword(BuildContext context, String id,String name, String descripcion,
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

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Editar contraseña con id: $id')),
    // );
  }

  void deletePassword(BuildContext context, String id, String name) async {

    final box = Hive.box<PasswordHiveObject>('passwords');

    Future<bool> tituloExiste(String name) async {
      return box.values.any((password) => password.name == name);
    }

    if(await tituloExiste(name) == true){
      box.delete(name);
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contraseña con id: $id eliminada correctamente')),
    );
  }
}
