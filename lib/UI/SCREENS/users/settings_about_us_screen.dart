import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Acerca de HiddenPass",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
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
                    SizedBox(height: 30),

                    Text(
                      "Política de Protección de Datos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),

                    _buildPolicySection(
                      "Información que Recopilamos",
                      """• Datos de autenticación local
• NO recopilamos datos personales identificables de ningun tipo.""",
                      isDarkMode,
                    ),

                    _buildPolicySection(
                      "Cómo Protegemos tus Datos",
                      """• Cifrado AES-256 de nivel militar para todas las contraseñas
• Los datos se almacenan únicamente en tu dispositivo local
• No transmitimos contraseñas ni información personal a servidores externos""",
                      isDarkMode,
                    ),
                    
                    _buildPolicySection(
                      "Almacenamiento de Datos",
                      """• Todos los datos se guardan localmente en tu dispositivo
• Las contraseñas nunca se almacenan en texto plano
• Utilizamos almacenamiento seguro del sistema operativo
• Los datos cifrados son inaccesibles sin tu clave maestra""",
                      isDarkMode,
                    ),


                    _buildPolicySection(
                      "HIDDENPASS es Privacidad por Diseño",
                      """
• Sin análisis de uso o telemetría
• Sin publicidad ni rastreadores
• Transparencia total en nuestro código""",
                      isDarkMode,
                    ),
                    Text("HIDDENPASS © 2025"),
                    SizedBox(height: 10),
                    Text(
                      "Última actualización: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'hiddenpassapp@gmail.com',
                        query: 'subject=Consulta sobre HiddenPass',
                      );
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No se pudo abrir el cliente de correo'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 45),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 8),
                        Text('Contáctanos'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Botón GitHub
                  ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                          'https://github.com/DorkoSpron0/Hidden-Pass');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No se pudo abrir GitHub'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 45),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.code),
                        SizedBox(width: 8),
                        Text('Visita nuestro GitHub'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: isDarkMode
                  ? Colors.grey[100]
                  : Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}