import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:provider/provider.dart';

class BottomItemWidget extends StatelessWidget {
  final IconData icon;
  final int index;

  const BottomItemWidget({super.key, required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    NavigationProvider watch = context.watch<NavigationProvider>();
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {
          context.read<NavigationProvider>().setNavigationIndex(index: index);
        },
        icon: Icon(
          icon,
          color: watch.index == index ? Colors.blue : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
