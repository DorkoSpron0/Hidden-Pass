import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/SCREENS/register_password_screen.dart';

class RegisterAvatar extends StatefulWidget {
  const RegisterAvatar({super.key});

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
    Navigator.pop(context);
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPassword()));
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
                    onPressed: () {
                      if (_selectedAvatar != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPassword()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Por favor, elige un avatar antes de continuar")),
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
