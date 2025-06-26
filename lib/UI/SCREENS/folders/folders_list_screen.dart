import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_widget.dart';



void main() => runApp(const FoldersListScreen());

class FoldersListScreen extends StatefulWidget {
  const FoldersListScreen({super.key});

  @override
  State<FoldersListScreen> createState() => _FoldersListScreenState();
}

class _FoldersListScreenState extends State<FoldersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center( 
          child: FolderListWidget(),
        ),
    );
  }
}