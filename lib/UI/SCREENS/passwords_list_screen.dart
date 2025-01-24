import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widget.dart';
//import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widget.dart';
//import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';
// import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/card_widget.dart';

class PasswordsListScreen extends StatelessWidget {
  const PasswordsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(context),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        // ),

        body: Stack(
          children: [
            PasswordListBodyWidget(),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarWidget(),
            ),
          ],
        ));
  }
}
