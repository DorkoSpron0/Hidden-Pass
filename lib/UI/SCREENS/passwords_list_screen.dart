import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/settings_screen.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';

class PasswordsListScreen extends StatefulWidget {
  const PasswordsListScreen({super.key});

  @override
  State<PasswordsListScreen> createState() => _PasswordsListScreenState();
}

class _PasswordsListScreenState extends State<PasswordsListScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PasswordListBodyWidget(),
    NotesListScreen(),
    SettingsScreen()
  ];

// TODO - AFTER SETTINGS GLOBAL STATE - REFACTOR CODE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 65,
        margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Color(0XFF131313),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                  size: 24,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.message,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                  size: 24,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.white,
                  size: 24,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
