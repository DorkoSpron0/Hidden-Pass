import 'package:flutter/material.dart';

Future<bool> cerrarSesion(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro que deseas cerrar sesión?.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
            'Cerrar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      backgroundColor: Colors.grey[900],
    ),
  ) ?? false;
}
