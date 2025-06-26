import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<bool> deleteFolder(String id, BuildContext context) async {
    final token = context.read<TokenAuthProvider>().token.trim();
    final idUser = context.read<IdUserProvider>().idUser.trim();
    
    if (token != null && idUser != null){

      var url = Uri.parse(ApiConfig.endpoint("/folders/$id"));

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La carpeta se ha eliminado con exito!'))
        );

        Provider.of<DataListProvider>(context, listen: false).reloadFolderList(<Map<String, dynamic>>[]);

        return true;
      }
      return false;
    }
    return false;
  }