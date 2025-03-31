import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/add_notas_screen.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/settings_screen.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';
import 'package:provider/provider.dart';

class PricipalPageScreen extends StatelessWidget {

  const PricipalPageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    NavigationProvider watch = context.watch<NavigationProvider>(); // get Navigation GlobalIndex
    TokenAuthProvider watchAuth = context.watch<TokenAuthProvider>();

    final List<Widget> pages = [
      PasswordListBodyWidget(),
      NotesListScreen(),
      SettingsScreen()
    ];

    final List<String> titles = ["Contraseñas", "Notas", "Configuración"];

    print(watchAuth.token);

    return Scaffold(
      appBar: appBarWidget(context, titles[watch.index]),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child,);
            },
            child: IndexedStack( // Indexed stack para que no recargue cada vez que se navega
              key: ValueKey(watch.index),
              index: watch.index,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF131313),
        //shape: CircleBorder(), Boton circular
          onPressed: () async {
            if (watch.index == 1) { // 1 es el índice de la pantalla de notas
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()),
            );
            if (result == true) {
              // Actualizar la lista de notas si es necesario
            }
          } else {
            // Puedes agregar aquí una acción diferente para otras pantallas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Acción no disponible en esta pantalla')),
            );
          }
          },
          child: Icon(Icons.add, size: 30.0),
      ),
    );
  }
}
