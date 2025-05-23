import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/add_notas_screen.dart';
import 'package:hidden_pass/UI/SCREENS/create_new_folder_screen.dart';
import 'package:hidden_pass/UI/SCREENS/create_new_password_screen.dart';
import 'package:hidden_pass/UI/SCREENS/folders_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/notes_list_screen.dart';
import 'package:hidden_pass/UI/SCREENS/settings_screen.dart';
import 'package:hidden_pass/UI/WIDGETS/appbar_widget.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar.dart';
import 'package:hidden_pass/UI/WIDGETS/bottom_navigation_bar_widgets/bottom_item_widget_big.dart';
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';
import 'package:provider/provider.dart';

class PricipalPageScreen extends StatefulWidget {
  const PricipalPageScreen({super.key});

  @override
  State<PricipalPageScreen> createState() => _PricipalPageScreenState();
}

class _PricipalPageScreenState extends State<PricipalPageScreen> {
  @override
  Widget build(BuildContext context) {
    final watch = context.watch<NavigationProvider>();
    final authProvider = context.watch<TokenAuthProvider>();
    final bool showFolders = authProvider.username != null && authProvider.username!.trim().isNotEmpty;

    // Definición de pantallas
    final passwordScreen = PasswordListBodyWidget();
    final foldersScreen = FoldersListScreen();
    final notesScreen = NotesListScreen();
    final settingsScreen = SettingsScreen();

    final pages = showFolders
        ? [passwordScreen, foldersScreen, notesScreen, settingsScreen]
        : [passwordScreen, notesScreen, settingsScreen];

    final titles = showFolders
        ? ["Contraseñas", "Carpetas", "Notas", "Configuración"]
        : ["Contraseñas", "Notas", "Configuración"];

    // Ajuste del índice visual
    int adjustedIndex = watch.index;
    if (!showFolders && adjustedIndex >= 1) {
      adjustedIndex -= 1;
    }

    return Scaffold(
      appBar: appBarWidget(context, titles[adjustedIndex]),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: IndexedStack(
              key: ValueKey(adjustedIndex),
              index: adjustedIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 600
          ? const BottomNavigationBarBigWidget()
          : const BottomNavigationBarWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () async {
          Widget? screenToOpen;

          if (adjustedIndex == 0) {
            screenToOpen = CreateNewPasswordScreen();
          } else if (adjustedIndex == 1) {
            screenToOpen = showFolders ? CreateNewFolderScreen() : AddNoteScreen();
          } else if (adjustedIndex == 2 && showFolders) {
            screenToOpen = AddNoteScreen();
          }

          if (screenToOpen != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screenToOpen!), // el ! es clave aquí
            );

            if (result == true) {
              // Recargar listas si es necesario
            }
          }
        },

        child: const Icon(Icons.add, size: 30.0),
      ),
    );
  }
}
