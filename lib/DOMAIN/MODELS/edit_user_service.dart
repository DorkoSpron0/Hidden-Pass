import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  Future<void> updateUserData(String userId, String token, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/users/update/$userId'),
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