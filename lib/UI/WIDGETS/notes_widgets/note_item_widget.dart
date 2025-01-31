import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteItemWidget extends StatelessWidget {
  const NoteItemWidget({super.key});

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
                Text("Nota 1"),
                Text("Enim cupidatat quis non ut."),
              ],
            ),
            Icon(Icons.arrow_forward_ios)
          ]),
        ),
      ),
    );
  }
}
