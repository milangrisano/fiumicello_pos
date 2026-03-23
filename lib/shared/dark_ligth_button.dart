import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/theme_provider.dart';

class DarkAndLightButton extends StatelessWidget {
  const DarkAndLightButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeProvider>().toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.all(8), // Espacio entre el icono y el círculo
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurfaceVariant,// Color de la circunferencia
            width: 1.5,         // Grosor de la línea
          ),
        ),
        child: Icon(
          context.watch<ThemeProvider>().isDarkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          size: 22,
        ),
      ),
    );
  }
}