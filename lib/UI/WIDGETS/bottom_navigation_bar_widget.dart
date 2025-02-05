import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widgets/bottom_item_widget.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Color(0XFF131313),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 0,
            spreadRadius: 3,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomItemWidget(icon: Icons.home, index: 0),
          BottomItemWidget(icon: Icons.message, index: 1),
          //BottomItemWidget(icon: Icons.search, index: 2),
          BottomItemWidget(icon: Icons.settings, index: 2),
        ],
      ),
    );
  }
}
