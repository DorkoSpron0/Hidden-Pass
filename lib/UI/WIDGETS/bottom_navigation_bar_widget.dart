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
            blurRadius: 10,
            spreadRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomItemWidget(
            icon: Icons.home_filled,
          ),
          BottomItemWidget(
            icon: Icons.message,
          ),
          BottomItemWidget(
            icon: Icons.search,
          ),
          BottomItemWidget(
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}
