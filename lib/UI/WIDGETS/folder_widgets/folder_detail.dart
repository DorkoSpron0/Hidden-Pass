import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';

class FolderPasswordListWidget extends StatefulWidget {
  final String folderId;
  final String name;
  final String folderDescription;

  const FolderPasswordListWidget({
    Key? key,
    required this.folderId,
    required this.name,
    required this.folderDescription,
  }) : super(key: key);

  @override
  State<FolderPasswordListWidget> createState() => _FolderPasswordListWidgetState();
}

class _FolderPasswordListWidgetState extends State<FolderPasswordListWidget> {
  List<Map<String, dynamic>> _passwordsList = [];
  bool _loadingPasswords = false;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    setState(() => _loadingPasswords = true);
    try {
      final token = context.read<TokenAuthProvider>().token.trim();
      final idUser = context.read<IdUserProvider>().idUser.trim();
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final url = Uri.parse(ApiConfig.endpoint("/passwords/$idUser"));

      final response = await http.get(
        url,
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> allPasswords = jsonDecode(utf8.decode(response.bodyBytes));
        final folderId = widget.folderId;

        final filteredPasswords = allPasswords
            .where((password) => password['id_folder']?.toString() == folderId)
            .cast<Map<String, dynamic>>()
            .toList();

        setState(() {
          _passwordsList = filteredPasswords;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar contraseñas: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loadingPasswords = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPasswords,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.folderDescription,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: _loadingPasswords
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 16.0),
                    itemCount: _passwordsList.length,
                    itemBuilder: (context, index) {
                      final password = _passwordsList[index];
                      final accountName = password['name'] ?? 'Sin nombre';
                      final emailValue = password['email_user'] ?? '';
                      final passwordValue = password['password'] ?? '';

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(20),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.secondary,
                            child: Text(
                              accountName.isNotEmpty ? accountName[0] : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(accountName, style: theme.textTheme.titleMedium),
                          subtitle: Text(emailValue, style: theme.textTheme.bodySmall),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: passwordValue));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Contraseña copiada')),
                              );
                            },
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
