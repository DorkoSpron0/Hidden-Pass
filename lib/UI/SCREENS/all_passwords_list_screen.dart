import 'package:flutter/material.dart';

void main() => runApp(const AllPasswordScreen());

class AllPasswordScreen extends StatelessWidget {
  const AllPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Todas las contraseñas iran aqui'),
        ),
      ),
    );
  }
}