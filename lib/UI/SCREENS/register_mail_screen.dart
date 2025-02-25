import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/register_password_screen.dart';
import 'package:hidden_pass/UI/SCREENS/register_screen.dart';


class RegisterMail extends StatefulWidget {
  const RegisterMail({super.key});

  @override
  _RegisterMailState createState() => _RegisterMailState();
}

class _RegisterMailState extends State<RegisterMail> {
  // Controlador para el campo de correo electrónico
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          double containerWidth = isSmallScreen ? constraints.maxWidth * 0.85 : constraints.maxWidth * 0.5;
          double reducedSpace = constraints.maxHeight * 0.12;

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 80,
                    vertical: isSmallScreen ? 20 : 80,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60 + reducedSpace),
                      SizedBox(
                        width: containerWidth,
                        child: Text(
                          "Ingresa tu correo electrónico",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: containerWidth,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController, // Asignamos el controlador
                          decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Flecha superior izquierda
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                ),
              ),
              // Flecha inferior derecha
              Positioned(
                bottom: 40,
                right: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff323232),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      // Verificar si el campo de correo electrónico está vacío
                      if (_emailController.text.isEmpty) {
                        // Mostrar un mensaje de error si el campo está vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Por favor ingresa un correo electrónico")),
                        );
                      } else {
                        // Si el campo no está vacío, navegar a la siguiente pantalla
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPassword(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
