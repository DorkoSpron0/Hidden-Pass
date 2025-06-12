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
import 'package:hidden_pass/UI/WIDGETS/password_list_widgets/password_list_body_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class PricipalPageScreen extends StatefulWidget {
  final int initialIndex;

  const PricipalPageScreen({super.key, this.initialIndex = 0});

  @override
  State<PricipalPageScreen> createState() => _PricipalPageScreenState();
}

class _PricipalPageScreenState extends State<PricipalPageScreen> {
  get initialIndex => null;

  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NavigationProvider>().setNavigationIndex(index: initialIndex);
      });
    final watch = context.watch<NavigationProvider>();
    final authProvider = context.watch<TokenAuthProvider>();
    final bool showFolders = authProvider.username != null &&
        authProvider.username!.trim().isNotEmpty;
    final bool isLargeScreen = MediaQuery.of(context).size.width > 800;

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

    if (isLargeScreen) {
      // Layout para pantallas grandes con sidebar vertical
      return Scaffold(
        body: Row(
          children: [
            // Sidebar vertical
            Container(
              width: 220,
              color: Color(0XFF131313),
              child: SafeArea(
                child: Column(
                  children: [
                    // Avatar section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[800],
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            authProvider.username ?? 'Usuario',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[700],
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 20),
                    // Navigation items
                    _buildVerticalNavItem(context, Icons.home_filled,
                        "Contraseñas", 0, adjustedIndex, showFolders),
                    if (showFolders)
                      _buildVerticalNavItem(context, Icons.folder, "Carpetas",
                          1, adjustedIndex, showFolders),
                    _buildVerticalNavItem(context, Icons.message, "Notas",
                        showFolders ? 2 : 1, adjustedIndex, showFolders),
                    _buildVerticalNavItem(
                        context,
                        Icons.settings,
                        "Configuración",
                        showFolders ? 3 : 2,
                        adjustedIndex,
                        showFolders),
                  ],
                ),
              ),
            ),
            // Contenido principal
            Expanded(
              child: Column(
                children: [
                  // AppBar para el contenido principal
                  Container(
                    height: 56.0,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    child: Row(
                      children: [
                        Text(
                          titles[adjustedIndex],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // Implementar búsqueda
                          },
                        ),
                      ],
                    ),
                  ),
                  // Contenido
                  Expanded(
                    child: AnimatedSwitcher(
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
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton:
            _buildFloatingActionButton(context, adjustedIndex, showFolders),
      );
    } else {
      // Layout para móviles con bottom navigation
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
        bottomNavigationBar: const BottomNavigationBarWidget(),
        floatingActionButton:
            _buildFloatingActionButton(context, adjustedIndex, showFolders),
      );
    }
  }

  Widget _buildVerticalNavItem(BuildContext context, IconData icon,
      String label, int index, int currentIndex, bool showFolders) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        int realIndex = index;
        if (!showFolders && index >= 1) {
          realIndex += 1;
        }
        context.read<NavigationProvider>().setNavigationIndex(index: realIndex);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, int adjustedIndex, bool showFolders) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      onPressed: () async {
        Widget? screenToOpen;

        if (adjustedIndex == 0) {
          screenToOpen = CreateNewPasswordScreen();
        } else if (adjustedIndex == 1) {
          screenToOpen =
              showFolders ? CreateNewFolderScreen() : AddNoteScreen();
        } else if (adjustedIndex == 2 && showFolders) {
          screenToOpen = AddNoteScreen();
        }

        if (screenToOpen != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenToOpen!),
          );

          if (result == true) {
            // Recargar listas si es necesario
          }
        }
      },
      child: const Icon(Icons.add, size: 30.0),
    );
  }
}
