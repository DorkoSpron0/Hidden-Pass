import 'package:flutter/material.dart';

class NotesListScreen extends StatefulWidget {
  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: bottomNavigationBarWidget(context),
      body: Center(
        child: Text("Notes List!"),
      ),
    );
  }
}
