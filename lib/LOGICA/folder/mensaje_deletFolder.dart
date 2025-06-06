import 'package:flutter/material.dart';

Future<bool> confirmacionDelete(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: const Text('¿Estás seguro que deseas eliminar este folder?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 53, 51, 51),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      backgroundColor: Colors.grey[900],
    ),
  ) ?? false;
}
