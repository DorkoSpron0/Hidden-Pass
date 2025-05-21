import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:hidden_pass/UI/SCREENS/users/settings_user__screen.dart';
import 'package:hidden_pass/UI/WIDGETS/settings_screen_widgets/settings_widget.dart';
import 'settings_about_us_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> fetchUserProfile(BuildContext context) async {
    final Token = context.read<TokenAuthProvider>().token;
    final IdUser = context.read<IdUserProvider>().idUser;

    if(Token.isNotEmpty){
      final response = await http.get(

        Uri.parse(ApiConfig.endpoint("/users/$IdUser")),

    headers: {
          'Authorization': 'Bearer $Token',
        },
      );

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(userData: userData)),
          );
        } else {
          print('Error al obtener el perfil del usuario: ${response.statusCode}');
        }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => fetchUserProfile(context),
              child: buildListTile("Mi perfil"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()),
                );
              },
              child: buildListTile("Acerca de"),
            ),
            buildVersionTile("Versión", "0.0.1"),
          ],
        ),
      ),
    );
  }
}