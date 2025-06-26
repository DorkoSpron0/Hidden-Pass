import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidden_pass/DOMAIN/HIVE/ADAPTERS/PasswordHiveAdapter.dart';
import 'package:hidden_pass/DOMAIN/HIVE/PasswordHiveObject.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/navigation_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/password_list_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:hidden_pass/UI/SCREENS/principal_page_screen.dart';
import 'dart:async';
import 'package:hidden_pass/UI/SCREENS/users/register_screen.dart';
import 'package:hidden_pass/UI/SCREENS/users/user_login_screen.dart';
import 'package:hidden_pass/UI/UTILS/theme_data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'DOMAIN/HIVE/ADAPTERS/NoteHiveAdapter.dart';
import 'DOMAIN/HIVE/NoteHiveObject.dart';
import 'UI/PROVIDERS/theme_provider.dart';
import 'inactivity_logout.dart'; // Para usar Timer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  } else {
    Hive.init(Directory.current.path);
  }

  // Bloquear solo orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Hive.registerAdapter(NoteHiveAdapter());
  Hive.registerAdapter(PasswordHiveAdapter());
  await Hive.openBox<NoteHiveObject>('notes');
  await Hive.openBox<PasswordHiveObject>('passwords');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _handleSessionTimeout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        showDialog(
          context: ctx,
          builder: (context) => AlertDialog(
            title: const Text('Aviso inactividad'),
            content: const Text('La sesión se ha cerrado por inactividad'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 53, 51, 51),
                ),
                onPressed: () {
                  Provider.of<TokenAuthProvider>(ctx, listen: false).setToken(
                    token: '',
                    username: '',
                    avatarUrl: '',
                  );
                  Provider.of<IdUserProvider>(ctx, listen: false).setidUser(
                    idUser: '',
                  );
                  Provider.of<DataListProvider>(ctx, listen: false).reloadPasswordList([]);
                  Provider.of<DataListProvider>(ctx, listen: false).reloadNoteList([]);
                  Provider.of<DataListProvider>(ctx, listen: false).reloadFolderList([]);

                  Navigator.of(ctx).pop(); // Cierra el diálogo
                  navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => UserLogin()),
                        (route) => false,
                  );
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TokenAuthProvider()),
        ChangeNotifierProvider(create: (_) => IdUserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DataListProvider()),
      ],
      builder: (context, _) {
        final themeData = Provider.of<ThemeProvider>(context);

        return InactivityLogout(
          timeoutDuration: const Duration(minutes: 5),
          onTimeout: _handleSessionTimeout,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Hidden Pass',
            themeMode: themeData.themeMode,
            theme: customThemeData(isDarkMode: false),
            darkTheme: customThemeData(isDarkMode: true),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TokenAuthProvider>()
          .setToken(token: "", username: '', avatarUrl: '');
    });

    super.initState();
    // Hacemos que la pantalla de inicio cambie después de 2 segundos
    Timer(const Duration(seconds: 2), () {
      // Navegar a la pantalla siguiente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/LogoSimple.png',
            width: 600,
            height: 625,
          ),
        ]),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/LogoSimple.png',
            width: 346,
            height: 361,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5d5d5d),
              padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
            ),
            child: Text(
              'Registrarse',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 102, vertical: 20),
              backgroundColor: Color(0xff323232),
              side: BorderSide(color: Color(0xff5d5d5d), width: 2),
            ),
            onPressed: () {
              // Navegar a la pantalla de login
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserLogin()));
            },
            child: Text(
              'Ya tengo una cuenta',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            child: Text(
              'Ingresar sin iniciar sesión',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PricipalPageScreen(initialIndex: 0)),
            ),
          )
        ],
      )),
    );
  }
}
