import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_widget.dart';

class ListFavoritePasswords extends StatelessWidget {
  final String titleCard;
  final String descriptionCard;
  final Image image;
  final Size size;

  const ListFavoritePasswords(
      {super.key,
      required this.size,
      required this.titleCard,
      required this.descriptionCard,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * .25,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return FolderWidget(titleCard: titleCard, descriptionCard: descriptionCard, image: image);
        },
      ),
    );
  }
}
