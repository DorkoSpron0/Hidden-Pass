import 'package:flutter/material.dart';

class PasswordItem extends StatelessWidget {
  final String title;
  final String imageURL;

  //const PasswordItem({super.key});
  const PasswordItem({super.key, required this.title, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.green,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Expanded(
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
                        "design.steve@gmail.com",
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
