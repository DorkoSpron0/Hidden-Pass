import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PasswordItem extends StatelessWidget {
  final String title;
  final String imageURL;
  final String email;

  //const PasswordItem({super.key});
  const PasswordItem({super.key, required this.title, required this.imageURL, required this.email});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane:
          ActionPane(motion: DrawerMotion(), children: <SlidableAction>[
        SlidableAction(
          backgroundColor: Colors.red,
          onPressed: (context) {
            //TODO - DELETE THE PASSWORD
          },
          icon: Icons.delete,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        SlidableAction(
          onPressed: (context) {},
          icon: Icons.edit,
          backgroundColor: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        )
      ]),
      child: InkWell(
        hoverColor: Colors.green,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    imageURL,
                    width: 60,
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.content_copy))
            ],
          ),
        ),
      ),
    );
  }
}
