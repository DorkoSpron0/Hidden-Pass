import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool isFavorite;
  NoteItemWidget({super.key, required this.title, required this.description, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane:
          ActionPane(motion: DrawerMotion(), children: <SlidableAction>[
        SlidableAction(
          onPressed: (context) {},
          icon: Icons.delete,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        SlidableAction(
          onPressed: (context) {},
          icon: Icons.edit,
          backgroundColor: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        )
      ]),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(80),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios)
          ]),
        ),
      ),
    );
  }
}
