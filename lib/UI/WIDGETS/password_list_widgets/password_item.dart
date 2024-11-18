import 'package:flutter/material.dart';

class PasswordItem extends StatelessWidget {
  const PasswordItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.green,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/LogoSimple.png',
                  width: 80,
                  height: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Behance",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                    Text("design.steve@gmail.com"),
                  ],
                ),
              ],
            ),
            Icon(Icons.content_copy)
          ],
        ),
      ),
    );
  }
}
