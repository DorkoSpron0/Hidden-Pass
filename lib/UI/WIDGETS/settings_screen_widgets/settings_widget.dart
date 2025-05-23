// settings_widgets.dart
import 'package:flutter/material.dart';

Widget buildListTile(String title) {
  return ListTile(
    title: Text(title),
    trailing: Icon(Icons.chevron_right),
  );
}

Widget buildVersionTile(String title, String version) {
  return ListTile(
    title: Text(title),
    trailing: Text(version),
  );
}