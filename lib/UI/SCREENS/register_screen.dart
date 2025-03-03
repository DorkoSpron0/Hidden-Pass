import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/register_mail_screen.dart';
import 'package:hidden_pass/UI/SCREENS/register_username_screen.dart';
import 'package:hidden_pass/main.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 80,
                vertical: isSmallScreen ? 10 : 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,  // Cambié spaceBetween por spaceAround
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "TE DAMOS LA BIENVENIDA A",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/LogoSimple.png',
                    width: isSmallScreen ? 200 : 250,  // Imagen más grande en pantallas pequeñas
                    height: isSmallScreen ? 200 : 250, // Imagen más grande en pantallas pequeñas
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Gestiona tus contraseñas de forma segura y eficiente. Protege tu privacidad y la de tus datos valiosos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 20,
                      color: Colors.white70,
                    ),
                  ),
                  // Espaciado adicional si es necesario
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón "Continuar"
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterUsername()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 30 : 60,
                            vertical: isSmallScreen ? 10 : 15,
                          ),
                          backgroundColor: const Color(0xff323232),
                          side: const BorderSide(color: Color(0xff5d5d5d), width: 2),
                        ),
                        child: Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 18,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 20),
                      // Botón "Volver"
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          backgroundColor: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 30 : 60,
                            vertical: isSmallScreen ? 10 : 15,
                          ),
                        ),
                        child: Text(
                          "Volver",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}