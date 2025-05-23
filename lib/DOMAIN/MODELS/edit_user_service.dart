import 'dart:convert';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<void> updateUserData(String userId, String token, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse(ApiConfig.endpoint("/users/update/$userId")),

    headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar los datos: ${response.statusCode}');
    }
  }
}