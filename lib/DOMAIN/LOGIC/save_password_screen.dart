// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
// import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// void savePassword(String name, String url, String email_user, String password,
//     String description, BuildContext context) async {

//   final Token = context.read<TokenAuthProvider>().token;
//   final IdUser = context.read<IdUserProvider>().idUser;

//   if (Token == null || Token.isEmpty) {
//     print("Guardar contraseña localmente");
//     return;
//   }else{
//     final Url = Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/passwords/$IdUser');
// // http://10.0.2.2:8081/api/v1/hidden_pass/users/register
//   var Body = json.encode({
//     "name": name,
//     "url": url,
//     "email_user": email_user,
//     "password": password,
//     "description": description,
//   });

//   var response = await http.post(
//     Url,
//     body:Body,
//     headers: { 'conten-Type': 'application/json','Authorization':'Bearer $Token' }
  
//   );


//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     print("Contraseña guardada correctamente");
//   } else {
//     print("Error al guardar la contraseña: ${response.statusCode}");
//   }
//   }

//   // Implement the logic to save the password
// }
