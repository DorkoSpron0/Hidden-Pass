import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String name;
  final Image image;

  const CardWidget({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFF5D5D5D),
      child: Column(
        children: [
          image,
          Text(name),
        ],
      ),
    );
  }
}
