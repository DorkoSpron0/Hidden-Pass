import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarBigWidget extends StatelessWidget {
  const BottomNavigationBarBigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationProvider watch = context.watch<NavigationProvider>();

    return Container(
      color: Color(0XFF131313),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home_filled, "INICIO", 0, watch.index),
          _buildNavItem(context, Icons.folder, "CARPETAS", 1, watch.index),
          _buildNavItem(context, Icons.message, "NOTAS", 2, watch.index),
          _buildNavItem(context, Icons.settings, "CONFIG", 3, watch.index),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, int currentIndex) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        context.read<NavigationProvider>().setNavigationIndex(index: index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white30, size: 36),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white30)),
        ],
      ),
    );
  }
}