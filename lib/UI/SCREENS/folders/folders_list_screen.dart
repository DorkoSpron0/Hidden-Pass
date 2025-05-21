import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_widget.dart';

import '../../WIDGETS/password_list_widgets/all_passwords_list.dart';


void main() => runApp(const FoldersListScreen());

class FoldersListScreen extends StatefulWidget {
  const FoldersListScreen({super.key});

  @override
  State<FoldersListScreen> createState() => _FoldersListScreenState();
}

class _FoldersListScreenState extends State<FoldersListScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crear contraseñas',
      theme: customThemeData(),
      home: Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          actions: <Widget>[],
        ),
        body: Center( 
          child: FolderListWidget(),
        ),
      ),
    );
  }
}