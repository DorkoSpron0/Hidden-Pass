import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hidden_pass/UI/SCREENS/recover_password_screen.dart';
import 'package:hidden_pass/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:provider/provider.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoadingForgotPassword = false; // Nuevo estado para el loader

  void sendData(String email, String password) async {
    var url = Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/users/login'); 
    // 10.0.2.2:8081
    var body = json.encode({
      'email': email.trim(),
      'master_password': password.trim(),
    });

    var response = await http.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      // Asignar el token a través del provider
      context.read<TokenAuthProvider>().setToken(token: response.body);

      // Decodificar el token y obtener el ID del usuario
      void decodificarToken(String token) {
        try {
          final jwt = JWT.decode(token);
          final sub = jwt.payload['sub'];  
          context.read<IdUserProvider>().setidUser(idUser: sub);
        } catch (e) {
          print("Error al decodificar el JWT: $e");
        }
      }

      decodificarToken(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PricipalPageScreen())
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciales incorrectas")));
    }
  }

  void sendEmail(String email) async {
    setState(() {
      _isLoadingForgotPassword = true; // Mostrar el loader
    });

    var url = Uri.parse('http://10.0.2.2:8081/api/v1/hidden_pass/codes/send');

    var body = json.encode({
      'email': email,
    });

    try {
      var response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CodigoVerificacion(
                      email: email,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al enviar el código")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error de conexión")));
    } finally {
      setState(() {
        _isLoadingForgotPassword = false; // Ocultar el loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          double containerWidth =
              isSmallScreen ? constraints.maxWidth * 0.85 : constraints.maxWidth * 0.5;
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
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
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: "Contraseña",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          if (_emailController.text.isNotEmpty) {
                            sendEmail(_emailController.text.trim());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Por favor ingresa un correo válido")),
                            );
                          }
                        },
                      ),
                      if (_isLoadingForgotPassword) // Mostrar el loader condicionalmente
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("Enviando código de autorización...",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 40,
                right: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff323232),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      sendData(_emailController.text.trim(),
                          _passwordController.text.trim());
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
