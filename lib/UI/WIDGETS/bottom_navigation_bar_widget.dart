import 'package:flutter/material.dart';

BottomNavigationBar bottomNavigationBarWidget(BuildContext context) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.folder), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.note_add_rounded), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
    ],
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.white,
    iconSize: 32,
    showSelectedLabels: false,
    showUnselectedLabels: false,
  );
}
