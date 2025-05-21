import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/notes/add_notas_screen.dart';
import 'package:hidden_pass/UI/SCREENS/notes/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/passwords/create_new_folder_screen.dart';
import 'package:hidden_pass/UI/SCREENS/passwords/create_new_password_screen.dart';
import 'package:hidden_pass/UI/SCREENS/folders/folders_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/users/settings_screen.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widgets/bottom_item_widget_big.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';
import 'package:provider/provider.dart';

class PricipalPageScreen extends StatefulWidget {
  const PricipalPageScreen({super.key});

  @override
  State<PricipalPageScreen> createState() => _PrincipalPageScreenState();
}

class _PrincipalPageScreenState extends State<PricipalPageScreen> {
  @override
  Widget build(BuildContext context) {
    NavigationProvider watch = context.watch<NavigationProvider>();
    TokenAuthProvider watchAuth = context.watch<TokenAuthProvider>();

    final List<Widget> pages = [
      PasswordListBodyWidget(),
      FoldersListScreen(),
      NotesListScreen(),
      SettingsScreen()
    ];

    final List<String> titles = ["Contraseñas", "Carpetas", "Notas", "Configuración"];

    return Scaffold(
      appBar: appBarWidget(context, titles[watch.index]),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: IndexedStack(
              key: ValueKey(watch.index),
              index: watch.index,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 600
          ? BottomNavigationBarBigWidget()
          : BottomNavigationBarWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF131313),
        shape: CircleBorder(),
        onPressed: () async {
          if (watch.index == 1) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNewFolderScreen()),
            );
            if (result == true) {
              // Actualizar la lista de notas si es necesario
            }
          }else if (watch.index == 2) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()),
            ); if (result == true) {
              // Actualizar la lista de notas si es necesario
            }
          } else if (watch.index == 0) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()),
            ); if (result == true) {
              // Actualizar la lista de notas si es necesario
            }
          }
        },
        child: Icon(Icons.add, size: 30.0),
      ),
    );
  }
}