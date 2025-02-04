import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/folder_model.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_widget.dart';

class FoldersListScreen extends StatelessWidget {
  const FoldersListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<FolderModel> folderList = [
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/adobe.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/be.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/dinsey.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/netflix.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/photo.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/spotify.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/steam.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/adobe.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/adobe.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/dinsey.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/be.png"),
    ];

    return Scaffold(
      appBar: appBarWidget(context, "Carpetas"),
      body: GridView.builder(
        itemCount: folderList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
        itemBuilder: (context, index) => Column(
          children: [
            InkWell(
              onTap: (){},
              child: FolderWidget(titleCard: folderList[index].title, descriptionCard: folderList[index].description, image: Image.asset(folderList[index].url)),
            ),
            SizedBox(height: 20.0,)
          ],
        )
      )
    );
  }
}