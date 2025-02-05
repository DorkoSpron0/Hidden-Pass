import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/folder_model.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/folder_widgets/folder_widget.dart';

class FoldersListScreen extends StatelessWidget {
  const FoldersListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<FolderModel> folderList = [
      FolderModel(title: "Email Folder", description: "Description importante muy larga", url: "assets/images/adobe.png"),
      FolderModel(title: "Bank Folder", description: "Description Dont care", url: "assets/images/be.png"),
      FolderModel(title: "Disney Folder", description: "Description care", url: "assets/images/dinsey.png"),
      FolderModel(title: "Netflix Folder", description: "Description", url: "assets/images/netflix.png"),
      FolderModel(title: "PhotoShop 1", description: "Description <3", url: "assets/images/photo.png"),
      FolderModel(title: "Folder 1", description: "Emails folder", url: "assets/images/spotify.png"),
      FolderModel(title: "Folder 1", description: "por folder", url: "assets/images/steam.png"),
      FolderModel(title: "Folder 1", description: "videos fodler", url: "assets/images/adobe.png"),
      FolderModel(title: "Folder 1", description: "entertaiment folder", url: "assets/images/adobe.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/dinsey.png"),
      FolderModel(title: "Folder 1", description: "Dont care", url: "assets/images/be.png"),
    ];

    return Scaffold(
      appBar: appBarWidget(context, "Carpetas"),
      body: GridView.builder(
        shrinkWrap: true,
        itemCount: folderList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75), 
        itemBuilder: (context, index) => Column(
          children: [
            InkWell(
              onTap: (){},
              child: FolderWidget(titleCard: folderList[index].title, descriptionCard: folderList[index].description, image: Image.asset(folderList[index].url)),
            ),
          ],
        )
      )
    );
  }
}