import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final String titleCard;
  final String descriptionCard;
  final Image image;
  const FolderWidget(
      {super.key,
      required this.titleCard,
      required this.descriptionCard,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withAlpha(80),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            spreadRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(left: 50, right: 50, top: 10, bottom: 50, child: image),
          Positioned(
              bottom: 15,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleCard,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    descriptionCard,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
