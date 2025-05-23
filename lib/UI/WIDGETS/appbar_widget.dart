import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:provider/provider.dart';

AppBar appBarWidget(BuildContext context, String title) {
  final authProvider = context.watch<TokenAuthProvider>();
  final horaActual = DateTime.now().hour;
  final themeDate = Theme.of(context).colorScheme;

  print("Avatar: ${authProvider.avatar}, Username: ${authProvider.username}");

  return AppBar(
    elevation: 0,
    //backgroundColor: const Color(0XFF242424), //Color(0XFF242424),
    automaticallyImplyLeading: false,
    toolbarHeight: 80,
    flexibleSpace: LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16.0,
            right: 16.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lado izquierdo (avatar + texto)
              Align(
                alignment: Alignment.centerLeft,
                child: isSmallScreen
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: themeDate.secondary,
                            radius: 25,
                            backgroundImage: authProvider.avatar != null
                                ? (authProvider.avatar!.startsWith('http')
                                    ? NetworkImage(authProvider.avatar!)
                                    : AssetImage(authProvider.avatar!)
                                        as ImageProvider)
                                : null,
                            child: authProvider.avatar == null
                                ? const Icon(Icons.account_circle_rounded,
                                    size: 40.0,)
                                : null,
                          ),
                          /*
                          * Text(
                            authProvider.username ?? 'Usuario',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            saludo,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          */

                        ],
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: authProvider.avatar != null
                                ? (authProvider.avatar!.startsWith('http')
                                    ? NetworkImage(authProvider.avatar!)
                                    : AssetImage(authProvider.avatar!)
                                        as ImageProvider)
                                : null,
                            child: authProvider.avatar == null
                                ? const Icon(Icons.account_circle_rounded,
                                    size: 40.0,)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*
                              Text(
                                authProvider.username ?? 'Usuario',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                saludo,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              */
                            ],
                          ),
                        ],
                      ),
              ),

              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  iconSize: 40,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

String _obtenerSaludo(int hora) {
  if (hora < 12) return 'Buenos días';
  if (hora < 19) return 'Buenas tardes';
  return 'Buenas noches';
}
