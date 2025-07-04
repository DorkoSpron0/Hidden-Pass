import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden_pass/LOGICA/api_config.dart';
import 'package:hidden_pass/LOGICA/folder/folder_delet.dart';
import 'package:hidden_pass/LOGICA/folder/mensaje_deletFolder.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_detail.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_edit.dart';
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
    folders = context.read<DataListProvider>().folderList;
    if(folders.isEmpty){
      loadingFolders();
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadingFolders() async {
    final token = context.read<TokenAuthProvider>().token.trim();
    final idUser = context.read<IdUserProvider>().idUser.trim();

    setState(() => isLoading = true);
    //await Future.delayed(Duration(seconds: 5));

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.endpoint("/folders/$idUser")),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          folders = data.cast<Map<String, dynamic>>();
          debugPrint('Datos recibidos: $data');
        });

        Provider.of<DataListProvider>(context, listen: false).reloadFolderList(folders);

      } else {
        debugPrint('Error al cargar folders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al cargar folders: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> goToFolderDetail(Map<String, dynamic> folder) async {
     Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FolderPasswordListWidget(
        folderId: folder['id_folder'].toString(),
        name: folder['name'].toString(),
        folderDescription: folder['description'].toString(),
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        color: Theme.of(context).colorScheme.secondary,
      ));
    }

    if (folders.isEmpty) {
      return const Center(
        child: Text('No hay folders disponibles',
            style: TextStyle(color: Colors.white)),
      );
    }

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () => {
                  setState(() {
                    isLoading = true;
                    folders = <Map<String, dynamic>>[];
                    loadingFolders();
                  })
                },
                icon: Icon(Icons.refresh)
            ),
          ),
        ),

        Expanded(
          child: GridView.builder(
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
          ),
        )
      ],
    );
  }

  Widget _buildFolderItem(Map<String, dynamic> folder) {
    final iconPath = folder['icon']?.toString() ?? 'LogoSimple.png';
    final name = folder['name']?.toString() ?? 'Sin nombre';
    final description = folder['description']?.toString() ?? '';

    return GestureDetector(
      onTap: () => goToFolderDetail(folder),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDynamicIcon(iconPath),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'actualizar') {
                   
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FolderEditForm(folder: folder),
                      ),
                    );
                    if (result == true) {
                      await loadingFolders();
                    }
                    
                  } else if (value == 'eliminar') {
                    final id = folder['id_folder'];
                    final confirm = await confirmacionDelete(context);
                    if(confirm){
                      final deleted = await deleteFolder(id, context);
                    }
                    if (confirm) {
                      loadingFolders();
                    }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'actualizar', child: Text('Actualizar')),
                  PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                ],
              ),
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
            return const Icon(Icons.image, color: Colors.blue, size: 36);
          },
        ),
      ),
    );
  }
}
