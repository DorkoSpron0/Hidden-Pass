import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/password_model.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/list_favorite_passwords.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_item.dart';

class PasswordListBodyWidget extends StatelessWidget {
  const PasswordListBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final List<PasswordModel> passwordList = [
      PasswordModel(urlImage: "assets/images/be.png", title: "Behance", email: "nickyflorez09@test.com"),
      PasswordModel(urlImage: "assets/images/adobe.png", title: "Adobe", email: "manu26@test.com"),
      PasswordModel(urlImage: "assets/images/photo.png", title: "PhotoShop", email: "test@test.com"),
      PasswordModel(urlImage: "assets/images/dinsey.png", title: "Disney+", email: "email.test@tesst.com"),
      PasswordModel(urlImage: "assets/images/netflix.png", title: "Netflix", email: "mene@test.com"),
      PasswordModel(urlImage: "assets/images/steam.png", title: "Steam", email: "deivi@test.com"),
      PasswordModel(urlImage: "assets/images/spotify.png", title: "Spotify", email: "yo@test.com"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Tus Carpetas",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListFavoritePasswords(
          size: size,
          image: Image.asset('assets/images/adobe.png'),
          titleCard: "Title",
          descriptionCard: "Description",
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            "Todas tus contraseñas",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: size.height * .3,
            child: ListView.builder(
              itemCount: passwordList.length, // tamaño del array
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => Column(
                children: [
                  PasswordItem(
                    title: passwordList[index].title,
                    imageURL: passwordList[index].urlImage,
                    email: passwordList[index].email,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 82, 82, 82),
                    height: 20.0,
                  )
                ],
              ),
              shrinkWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
