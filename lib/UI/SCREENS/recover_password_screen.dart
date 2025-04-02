import 'dart:convert';
import 'package:hidden_pass/UI/SCREENS/new_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/user_login_screen.dart';

class CodigoVerificacion extends StatefulWidget {
  final String email;

  const CodigoVerificacion({super.key, required this.email});

  @override
  _CodigoVerificacionState createState() => _CodigoVerificacionState();
}

class _CodigoVerificacionState extends State<CodigoVerificacion> {
  final TextEditingController _codeController = TextEditingController();

  void sendCode(String email, String code) async {
    var url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/codes/validate');

    var body = json.encode({
      'email': email,
      'securityCode': code,
    });

    var response = await http.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Newpassword(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Credenciales incorrectas")));
    }
  }

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
                          "Ingresa el código de confirmación",
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
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: "Código de confirmación",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.check, color: Colors.grey),
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
                        builder: (context) => const UserLogin(),
                      ),
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
                      String code = _codeController.text.trim();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor ingrese un código de validación válido")));
                      } else {
                        sendCode(widget.email, code);
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
