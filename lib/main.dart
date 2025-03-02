import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'dart:async';

import 'package:hidden_pass/UI/SCREENS/register_screen.dart';
import 'package:hidden_pass/UI/SCREENS/user_login_screen.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';
import 'package:provider/provider.dart'; // Para usar Timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationProvider>(
              create: (_) => NavigationProvider())
        ],
        builder: (context, _) {
          return MaterialApp(
            title: 'Hidden Pas',
            theme: customThemeData(),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(), // Pantalla inicial
          );
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Hacemos que la pantalla de inicio cambie después de 3 segundos
    Timer(const Duration(seconds: 2), () {
      // Navegar a la pantalla siguiente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/LogoSimple.png',
            width: 600,
            height: 625,
          ),
        ]),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/LogoSimple.png',
            width: 346,
            height: 361,
          ),
          
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5d5d5d),
              padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
            ),
            child: Text(
              'Registrarse',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 102, vertical: 20),
              backgroundColor: Color(0xff323232),
              side: BorderSide(color: Color(0xff5d5d5d), width: 2),
            ),
            onPressed: () {
              // Navegar a la pantalla de login
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserLogin()));
            },
            child: Text(
              'Ya tengo una cuenta',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            child: Text(
            'Ingresar sin iniciar sesion',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PricipalPageScreen()),
          ),
          )
          
        ],
      )),
    );
  }
}


