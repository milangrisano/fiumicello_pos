import 'package:flutter/material.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';
import 'package:responsive_app/shared/app_colors.dart';

import 'package:provider/provider.dart';
import 'package:responsive_app/shared/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        primaryColor: AppColors.goldDark,
        colorScheme: const ColorScheme.light(
          primary: AppColors.goldDark,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.primaryTextLight,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.goldDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.goldDark,
          surface: AppColors.surfaceDark,
          onSurface: Colors.white,
        ),
      ),
      home: const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    );
  }
}
