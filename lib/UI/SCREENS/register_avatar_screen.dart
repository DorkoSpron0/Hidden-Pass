import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/user_login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'package:hidden_pass/UI/SCREENS/register_password_screen.dart';
import 'package:provider/provider.dart';

class RegisterAvatar extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const RegisterAvatar({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  _RegisterAvatarState createState() => _RegisterAvatarState();
}

class _RegisterAvatarState extends State<RegisterAvatar> {
  String? _selectedAvatar;

  final List<String> _avatarImages = [
    'assets/images/LogoSimple.png',
    'assets/images/perro.png',
    'assets/images/zorro.png',
    // 'assets/images/avatar4.png',
    // 'assets/images/avatar5.png',
    // 'assets/images/avatar6.png',
  ];

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = constraints.maxWidth > 600 ? 4 : 3; // Más columnas en pantallas grandes

            return Container(
              padding: EdgeInsets.all(20),
              height: 350,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _avatarImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectAvatar(_avatarImages[index]),
                    child: Image.asset(_avatarImages[index]),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void sendData() async {
    var url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/users/register'); // Asegúrate de que la URL esté bien

  // http://10.0.2.2:8081/api/v1/hidden_pass/users/register
    // Crear el cuerpo de la solicitud
    var body = json.encode({
      'username': widget.username,
      'email': widget.email,
      'master_password': widget.password,
      'url_image': _selectedAvatar, // Añadir la imagen seleccionada al cuerpo de la solicitud
    });

    // Realizar la solicitud POST
    var response = await http.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    print(body);

    if (response.statusCode == 201) {

      // context.read<TokenAuthProvider>().setToken(token: response.body);
      
      // void decodificarToken(String token) {
      //   try {
      //     final jwt = JWT.decode(token);
      //     print("Payload del JWT: ${jwt.payload}");
      //     final sub = jwt.payload['sub'];
      //     print('ID de usuario almacenado: $sub');
      //     context.read<IdUserProvider>().setidUser(idUser: sub);
      //   } catch (e) {
      //     print("Error al decodificar el JWT: $e");
      //   }
      // }

      // decodificarToken(response.body);
      // var data = json.decode(response.body); // Decodifica la respuesta del servidor
      // print('Datos enviados y recibidos: $data');
      print('codigo: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

    } else {
      print('Error en la solicitud: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}'); // Imprimir el cuerpo de la respuesta para depuración
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          double containerWidth = isSmallScreen ? constraints.maxWidth * 0.85 : constraints.maxWidth * 0.5;
          double avatarSize = isSmallScreen ? 80 : 120; // Tamaño del avatar según la pantalla
          double iconSize = isSmallScreen ? 28 : 36; // Tamaño de los iconos según la pantalla

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.15),
                      Text(
                        "Elige un avatar como foto de perfil",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showAvatarSelection,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: avatarSize / 2,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _selectedAvatar != null ? AssetImage(_selectedAvatar!) : null,
                            ),
                            if (_selectedAvatar == null)
                              Icon(Icons.add, color: Colors.white, size: iconSize),
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
                  iconSize: iconSize,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPassword(
                          email: widget.email,
                          password: widget.password,
                          username: widget.username,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 40,
                right: 20,
                child: Container(
                  width: iconSize + 24,
                  height: iconSize + 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff323232),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                  ),
                  child: IconButton(
                    iconSize: iconSize,
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: (){
                      if (_selectedAvatar == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Debes selccionar un avatar para poder avanzar")));
                      } else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLogin(),
                          ),
                        );
                      sendData();
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
