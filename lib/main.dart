import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'dart:async';

import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
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
          // Text(
          //   'HIDDEN PASS',
          //   style: TextStyle(fontSize: 50,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.white),
          // ),
          // espacio entre el boton y el texto
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
              //Luego pongo la accion
            },
            child: Text(
              'Ya tengo una cuenta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      )),
    );
  }
}


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600; // Determina si es móvil o tablet/PC

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 80, // Ajusta margen
                  vertical: isSmallScreen ? 20 : 80, // Ajusta espaciado
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: isSmallScreen ? 100 : 50),
                    Text(
                      "TE DAMOS LA BIENVENIDA A",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    Image.asset(
                      'assets/images/LogoSimple.png',
                      width: isSmallScreen ? 250 : 400,
                      height: isSmallScreen ? 250 : 400,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    Text(
                      "Gestiona tus contraseñas de forma segura y eficiente. Protege tu privacidad y la de tus datos valiosos. Nuestra app asegura que tus claves estén a salvo. Tu tranquilidad y seguridad son nuestra prioridad.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 20,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const PricipalPageScreen()),
                        (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 40 : 80,
                          vertical: isSmallScreen ? 15 : 20,
                        ),
                        backgroundColor: const Color(0xff323232),
                        side: const BorderSide(color: Color(0xff5d5d5d), width: 2),
                        
                      ),
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 20,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterMail()),
                        (Route<dynamic> route) => false);
                      }, 
                      child: Text("mail",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 20,
                        ),
                      ),
                      
                      ),
                    SizedBox(height: isSmallScreen ? 30 : 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////

class RegisterMail extends StatelessWidget {
  const RegisterMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600; // Determina si es móvil o tablet/PC
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 80, // Ajusta margen
                  vertical: isSmallScreen ? 20 : 80, // Ajusta espaciado
                ),
                ///////////// voy aquí
              ),
            ),
          ); 
        },
      ),
    );
  }
}

