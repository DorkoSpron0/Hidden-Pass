import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: Color(0XFF242424),
    automaticallyImplyLeading: true, // Ocultar la flecha de retroceso
    toolbarHeight: 80,
    leading: IconButton(
      onPressed: (){}, 
      icon: Icon(Icons.account_circle_rounded),
      iconSize: 40.0,
    ),
    title: Center(child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.search),
        iconSize: 40,
      ),
    ],
  );
}
