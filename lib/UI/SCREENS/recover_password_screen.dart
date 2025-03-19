import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/new_password_screen.dart';
import 'package:hidden_pass/UI/SCREENS/register_mail_screen.dart';
import 'package:hidden_pass/UI/SCREENS/register_screen.dart';
import 'package:hidden_pass/UI/SCREENS/user_login_screen.dart';

class CodigoVerificacion extends StatefulWidget {
  const CodigoVerificacion({super.key});

  @override
  _CodigoVerificacionState createState() => _CodigoVerificacionState();
}

class _CodigoVerificacionState extends State<CodigoVerificacion> {
  final TextEditingController _usernameController = TextEditingController();

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
                          "Ingreasa el codigo de confirmacion",
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
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Codigo de confirmacion",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.check, color: Colors.grey), // Cambia el color a verde o el que prefieras
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
                        builder: (context) => const UserLogin(email: 'mail', password: '',)
                      )
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
                      String username = _usernameController.text.trim();
                      if (username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor ingrese un codigo de validacion valido")));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Newpassword(),
                          ),
                        );
                      }
                    }
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
