import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widget.dart';

class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      //bottomNavigationBar: bottomNavigationBarWidget(context),
      body: Center(
        child: Text("Tasks List!"),
      ),
    );
  }
}
