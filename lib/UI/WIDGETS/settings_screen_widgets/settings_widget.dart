// settings_widgets.dart
import 'package:flutter/material.dart';

Widget buildListTile(String title) {
  return ListTile(
    title: Text(title, style: TextStyle(color: Colors.white)),
    trailing: Icon(Icons.chevron_right, color: Colors.white),
  );
}

Widget buildVersionTile(String title, String version) {
  return ListTile(
    title: Text(title, style: TextStyle(color: Colors.white)),
    trailing: Text(version, style: TextStyle(color: Colors.white)),
  );
}