import 'package:flutter/material.dart';

class PasswordListWidget extends StatelessWidget {
  // Datos hard-coded de ejemplo
  final List<Map<String, String>> passwords = [
    {'id': '1', 'name': 'Behance', 'email': 'test@gmail.com'},
    {'id': '2', 'name': 'Adobe', 'email': 'test2@gmail.com'},
    {'id': '3', 'name': 'Netflix', 'email': 'test@gmail.com'},
    {'id': '4', 'name': 'Spotify', 'email': 'test@gmail.com'},
    {'id': '5', 'name': 'Youtube', 'email': 'ayudaporfavormemuero@gmail.com'},
    {'id': '6', 'name': 'Reddit', 'email': 'enelmacdonalnovendendona@gmail.co'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: passwords.length,
      itemBuilder: (context, index) {
        final item = passwords[index];
        return Dismissible(
          key: Key(item['id']!),
          background: slideRightBackground(context),
          secondaryBackground: slideLeftBackground(context),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(item['name']![0], style: TextStyle(color: Colors.white)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            title: Text(item['name']!, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(item['email']!, style: Theme.of(context).textTheme.bodySmall),
            trailing: IconButton(
              icon: Icon(Icons.copy, color: Colors.grey),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contraseña copiada al portapapeles (no se xd)')),
                );
              },
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              // Lógica para editar
              editPassword(context, item['id']!);
              return false;
            } else if (direction == DismissDirection.endToStart) {
              // Lógica para eliminar
              deletePassword(context, item['id']!);
              return false;
            }
            return false;
          },
        );
      },
    );
  }

  Widget slideRightBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Editar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.error,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Eliminar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 20),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  void editPassword(BuildContext context, String id) {
    // Aquí puedes agregar la lógica para editar la contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar contraseña con id: $id')),
    );
  }

  void deletePassword(BuildContext context, String id) {
    // Aquí puedes agregar la lógica para eliminar la contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contraseña con id: $id eliminada correctamente')),
    );
  }
}