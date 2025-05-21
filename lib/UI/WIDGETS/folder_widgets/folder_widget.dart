import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FolderListWidget extends StatefulWidget {
  const FolderListWidget({Key? key}) : super(key: key);

  @override
  State<FolderListWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  List<Map<String, dynamic>> folders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadingFolders();
  }
  
  Future<void> loadingFolders() async {
    final token = context.read<TokenAuthProvider>().token.trim();
    final idUser = context.read<IdUserProvider>().idUser.trim();
    
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.endpoint("/folders/$idUser")),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          folders = data.cast<Map<String, dynamic>>();
          debugPrint('Datos recibidos: $data');
        });
      } else {
        debugPrint('Error al cargar folders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al cargar folders: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (folders.isEmpty) {
      return const Center(
        child: Text('No hay folders disponibles', 
              style: TextStyle(color: Colors.white)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 0.95,
      ),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return _buildFolderItem(folder);
      },
    );
  }

  Widget _buildFolderItem(Map<String, dynamic> folder) {
    final iconPath = folder['icon']?.toString() ?? 'LogoSimple.png';
    final name = folder['name']?.toString() ?? 'Sin nombre';
    final description = folder['description']?.toString() ?? '';

    return Card(
      color: const Color(0xFF232323),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDynamicIcon(iconPath),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicIcon(String iconPath) {
    
    String cleanPath = iconPath.replaceFirst('images/', '');
    
    final assetPath = 'assets/images/$cleanPath';
    
    debugPrint('Ruta final del ícono: $assetPath');

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error cargando ícono: $error');
            return const Icon(Icons.image, 
                  color: Colors.blue, 
                  size: 36);
          },
        ),
      ),
    );
  }
}