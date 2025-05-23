import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Acerca de HiddenPass",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  """Esta idea nace tras ver el mal manejo que tienen las personas con sus contraseñas, 
usando la misma en varias paginas web, careciendo de cambios periodicos con el 
paso del tiempo, con caracteres sencillos (como 1234a etc) sin tener en cuenta la 
cantidad de información y vulnerabilidades que crean.

Bajo esta idea nace HIDDENPASS, aplicativo que busca mejorar la seguridad en las 
cuentas de las personas, ofreciendo generación de contraseñas seguras y diferentes, 
encriptándolas, haciendo, como consecuencia que tus cuentas sean mas seguras y 
prácticamente imposibles de hackear mediante ataques de fuerza bruta.
Nuestro aplicativo ofrecerá gestión de contraseñas con recordatorio para cambiarlas, 
con aplicativos nativos para PC y dispositivos móviles que se pueden sincronizar, 
contando también con gestión de notas seguras y posibilidad de rellenado automático 
al iniciar sesión.""",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://github.com/tu-repositorio');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'No se pudo abrir $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color de fondo
                  foregroundColor: Colors.white, // Color del texto
                ),
                child: Text('Visita nuestro GitHub'),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}