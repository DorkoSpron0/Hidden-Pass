// import 'package:flutter/material.dart';
// import 'package:hidden_pass/DOMAIN/HIVE/NoteHiveObject.dart';
// import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
// import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
// import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
// import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
// import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
// import 'package:hidden_pass/main.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';

// Future<void> deleteNote(BuildContext context) async {
//     final idNote;
//     final token = context.read<TokenAuthProvider>().token;
//     final box = Hive.box<NoteHiveObject>('notes');

//     if (token == null || token.isEmpty) {
//       // Borrar localmente si no hay token
//       box.delete(idNote);
//       print("Nota eliminada localmente: $idNote");
//     } else {
//       // Borrar en el backend si hay token
//       final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/$idNote');

//       try {
//         final response = await http.delete(
//           url,
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         );

//         if (response.statusCode == 200) {
//           print("Nota eliminada en el servidor: $idNote");
//         } else {
//           print("Error al eliminar en el backend: ${response.body}");
//         }
//       } catch (e) {
//         print("Error de conexión al eliminar nota: $e");
//       }
//     }
//   }