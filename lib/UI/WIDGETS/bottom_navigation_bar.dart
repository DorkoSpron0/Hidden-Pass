import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../PROVIDERS/token_auth_provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<NavigationProvider>();
    final authProvider = context.watch<TokenAuthProvider>();
    final bool showFolders = authProvider.username != null && authProvider.username!.trim().isNotEmpty;

    final navigationItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "INICIO"),
      if (showFolders)
        const BottomNavigationBarItem(icon: Icon(Icons.folder), label: "CARPETAS"),
      const BottomNavigationBarItem(icon: Icon(Icons.message), label: "NOTAS"),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "CONFIG"),
    ];

    // Calcular índice visible
    int adjustedIndex = watch.index;
    if (!showFolders && adjustedIndex >= 1) {
      adjustedIndex -= 1;
    }

    return BottomNavigationBar(
      currentIndex: adjustedIndex,
      onTap: (value) {
        HapticFeedback.selectionClick();

        int realIndex = value;
        if (!showFolders && value >= 1) {
          realIndex += 1;
        }

        context.read<NavigationProvider>().setNavigationIndex(index: realIndex);
      },
      type: BottomNavigationBarType.fixed,
      enableFeedback: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary.withAlpha(80),
      elevation: 20.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 30.0,
      items: navigationItems,
    );
  }
}
