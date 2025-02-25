import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/register_avatar_screen.dart';


class RegisterPassword extends StatefulWidget {
  const RegisterPassword({super.key});

  @override
  _RegisterPasswordState createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  // Controlador para el campo de contraseña
  final TextEditingController _passwordController = TextEditingController();

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
                          "Ingresa tu contraseña maestra, de al menos 8 caracteres",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔒 Campo Contraseña
                      Container(
                        width: containerWidth,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: _inputBoxDecoration(),
                        child: TextField(
                          controller: _passwordController,  // Usamos el controlador aquí
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔙 Flecha superior izquierda (Regresar)
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // 🔜 Flecha inferior derecha
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
                      // Verificar si el campo de contraseña está vacío
                      if (_passwordController.text.isEmpty) {
                        // Mostrar un mensaje de error si el campo está vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Por favor ingresa una contraseña")),
                        );
                      } else {
                        // Si el campo no está vacío, navegar a la siguiente pantalla
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterAvatar(),
                          ),
                          (Route<dynamic> route) => false,
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

  // 🔲 Estilo del contenedor de entrada
  BoxDecoration _inputBoxDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
        ),
      ],
    );
  }
}

