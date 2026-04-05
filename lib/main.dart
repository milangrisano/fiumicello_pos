import 'package:flutter/material.dart';
import 'package:responsive_app/router/app_router.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_app/provider/theme_provider.dart';
import 'package:responsive_app/provider/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: AuthProvider.instance),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        primaryColor: const Color(0xFFD4AF37),
        hintColor: const Color(0xFFAAAAAA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD4AF37),
          secondary: Color.fromARGB(255, 179, 142, 21),
          tertiary: Color.fromARGB(255, 212, 175, 55),
          surface: Color(0xFFF8F5EC),
          onSurface: Color(0xFF1A1A1A),
          onSurfaceVariant: Color(0xFF888888),
          outline: Color(0xFF666666),
          outlineVariant: Color(0xFFD4C5A3),
          primaryContainer: Color(0xFF2D5A27),
          onPrimaryContainer: Colors.white,
          secondaryContainer: Color(0xFF1E3A8A),
          onSecondaryContainer: Colors.white,
          tertiaryContainer: Color(0xFFD97706),
          onTertiaryContainer: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 68, 64, 64),
        primaryColor: const Color(0xFFD4AF37),
        hintColor: const Color(0xFFAAAAAA),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color.fromARGB(255, 179, 142, 21),
          tertiary: Color.fromARGB(255, 212, 175, 55),
          surface: Color(0xFF2C2C2C),
          onSurface: Colors.white,
          onSurfaceVariant: Color(0xFF888888),
          outline: Color(0xFF666666),
          outlineVariant: Color(0xFFD4C5A3),
          primaryContainer: Color(0xFF2D5A27),
          onPrimaryContainer: Colors.white,
          secondaryContainer: Color(0xFF1E3A8A),
          onSecondaryContainer: Colors.white,
          tertiaryContainer: Color(0xFFD97706),
          onTertiaryContainer: Colors.white,
        ),
      ),
    );
  }
}
//TODO: cuando te logeas en el pos no debe expirar el token si estas logeado pero deberia refrescarse verificar metodo de refresco de token de Fernando Herrera