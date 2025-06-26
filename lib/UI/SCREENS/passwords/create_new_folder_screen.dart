import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_form.dart';

void main() => runApp(const CreateNewFolderScreen());

class CreateNewFolderScreen extends StatelessWidget {
  const CreateNewFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Nueva carpeta'),
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                FolderForm(),
              ],
            ),
          ),
        ),
    );
  }
}