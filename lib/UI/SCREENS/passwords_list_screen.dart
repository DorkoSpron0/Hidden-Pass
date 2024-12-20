import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/list_favorite_passwords.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_item.dart';
// import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/card_widget.dart';

class PasswordsListScreen extends StatelessWidget {
  const PasswordsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBarWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Tus favoritas",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListPasswords(
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
                  itemCount: 16,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => PasswordItem(),
                  shrinkWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
