import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {

    NavigationProvider watch = context.watch<NavigationProvider>();
        
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.white10,
      ),
      child: BottomNavigationBar(
          onTap: (value) => {
            HapticFeedback.selectionClick(),
            context.read<NavigationProvider>().setNavigationIndex(index: value)
          },
          currentIndex: watch.index,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          backgroundColor: Color(0XFF131313),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white30,
          elevation: 20.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 30.0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "INICIO",),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "NOTAS"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "CONFIG"),
          ]
        ),
    );
  }
}