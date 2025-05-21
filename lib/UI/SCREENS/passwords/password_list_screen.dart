import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/password_model.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_item.dart';

class PasswordListScreen extends StatelessWidget {
  const PasswordListScreen({super.key});

  @override
  Widget build(BuildContext context) {

final List<PasswordModel> passwordList = [
      PasswordModel(
          urlImage: "assets/images/be.png",
          title: "Behance",
          email: "nickyflorez09@test.com"),
      PasswordModel(
          urlImage: "assets/images/adobe.png",
          title: "Adobe",
          email: "manu26@test.com"),
      PasswordModel(
          urlImage: "assets/images/photo.png",
          title: "PhotoShop",
          email: "test@test.com"),
      PasswordModel(
          urlImage: "assets/images/dinsey.png",
          title: "Disney+",
          email: "email.test@tesst.com"),
      PasswordModel(
          urlImage: "assets/images/netflix.png",
          title: "Netflix",
          email: "mene@test.com"),
      PasswordModel(
          urlImage: "assets/images/steam.png",
          title: "Steam",
          email: "deivi@test.com"),
      PasswordModel(
          urlImage: "assets/images/spotify.png",
          title: "Spotify",
          email: "yo@test.com"),
    ];

    return Scaffold(
      appBar: appBarWidget(context, "Contraseñas"),
      body: ListView.builder(
        itemCount: passwordList.length,
        itemBuilder: (context, index) => Column(
          children: [
            InkWell(
              onTap: (){}, // TODO - Navigate to Password Details Page 
              child: PasswordItem(title: passwordList[index].title, imageURL: passwordList[index].urlImage, email: passwordList[index].email),
            ), 
            SizedBox(height: 20.0,)
          ],
        ),
      )
    );
  }
}