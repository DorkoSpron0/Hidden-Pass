import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<void> deletePassword(
  String idPassword,
  String name,
  String url,
  String emailUser,
  String description,
  String password,
  String dateTime, // <-- importante
  BuildContext context,
) async {
  try {
    final token = context.read<TokenAuthProvider>().token.trim();
    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

    final urlApi = Uri.parse(ApiConfig.endpoint("/passwords/$idPassword"));

    final body = json.encode({
      "name": name,
      "url": url,
      "email_user": emailUser,
      "description": description,
      "password": password,
      "id_folder": null,         // <- folder vacío o null si es "remover"
      "dateTime": dateTime       // <- este campo es obligatorio
    });

    final response = await http.put(
      urlApi,
      headers: {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña removida del folder')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al remover: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

