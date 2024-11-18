import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/list_passwords.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_item.dart';
// import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/card_widget.dart';

class PasswordsListScreen extends StatelessWidget {
  const PasswordsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle_sharp),
        centerTitle: true,
        title: Text(
          "Contraseñas",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          Icon(Icons.add),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Tus favoritas",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListPasswords(size: size),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: size.height * .5,
              child: ListView.builder(
                itemCount: 16,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => PasswordItem(),
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
