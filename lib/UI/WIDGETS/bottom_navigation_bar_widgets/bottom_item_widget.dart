import 'package:flutter/material.dart';

class BottomItemWidget extends StatelessWidget {
  final IconData icon;

  const BottomItemWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ));
  }
}
