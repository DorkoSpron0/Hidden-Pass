import 'package:flutter/material.dart';

class FolderWidget extends StatefulWidget {
  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  // Datos hard-coded de ejemplo, listos para ser reemplazados por datos de una API
  final List<Map<String, String>> passwords = [
    {'id': '1', 'name': 'Behance', 'description': 'Description 1', 'logo': 'behance'},
    {'id': '2', 'name': 'Adobe', 'description': 'Description 1', 'logo': 'adobe'},
    {'id': '3', 'name': 'Behance', 'description': 'Description 1', 'logo': 'behance'},
    {'id': '4', 'name': 'Behance', 'description': 'Description 1', 'logo': 'behance'},
    {'id': '5', 'name': 'Behance', 'description': 'Description 1', 'logo': 'behance'},
    {'id': '6', 'name': 'Behance', 'description': 'Description 1', 'logo': 'behance'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 0.95,
      ),
      itemCount: passwords.length,
      itemBuilder: (context, index) {
        final item = passwords[index];
        return _PasswordCard(
          name: item['name']!,
          description: item['description']!,
          logo: item['logo']!,
        );
      },
    );
  }
}

class _PasswordCard extends StatelessWidget {
  final String name;
  final String description;
  final String logo;

  const _PasswordCard({
    required this.name,
    required this.description,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    // Aquí puedes personalizar los logos según el nombre o usar imágenes de assets
    if (logo == 'behance') {
      return Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFF1877F2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'Bē',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (logo == 'adobe') {
      return Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.ac_unit, color: Colors.white, size: 36), // Cambia por el logo real si tienes asset
        ),
      );
    } else {
      return Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.lock, color: Colors.white, size: 36),
        ),
      );
    }
  }
}