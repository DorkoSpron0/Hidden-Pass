import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context) {
  return AppBar(
    backgroundColor: Color(0XFF242424),
    toolbarHeight: 80,
    title: Text(
      "Contraseñas",
      style: Theme.of(context).textTheme.titleMedium,
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.search),
        iconSize: 40,
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.account_circle_sharp),
        iconSize: 40,
      ),
    ],
  );
}
