import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class GlobalSalesStatsPage extends StatelessWidget {
  const GlobalSalesStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Estadísticas Globales', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/utilities'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Estadísticas Globales de Venta',
              style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Esta página ha sido reservada para futuras integraciones.\nAquí se visualizarán gráficas y métricas comparativas de todos los restaurantes.',
              style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
