import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/register_avatar_screen.dart';
import 'package:hidden_pass/UI/SCREENS/user_login_screen.dart';

class Newpassword extends StatefulWidget {
  const Newpassword({super.key});

  @override
  _NewpasswordState createState() => _NewpasswordState();
}

class _NewpasswordState extends State<Newpassword> {
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
        r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    return passwordRegExp.hasMatch(password);
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
                          "Ingresa tu nueva contraseña",
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
                          controller: _passwordController,
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
              // Flecha superior izquierda
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
                      String password = _passwordController.text.trim();
                      if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor ingresa una contraseña")));
                      } else if (!_isValidPassword(password)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("La contraseña debe contener al menos 8 caracteres, una letra mayúscula, una minúscula, un número y un carácter especial")));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLogin(email: '', password: '',),
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
