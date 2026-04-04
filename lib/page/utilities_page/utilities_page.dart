import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';

class UtilitiesPage extends StatelessWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> utilityItems = [
      {'title': 'Roles', 'icon': Icons.admin_panel_settings, 'path': '/roles'},
      {'title': 'Restaurants', 'icon': Icons.restaurant, 'path': '/restaurants'},
      {'title': 'Terminal', 'icon': Icons.point_of_sale, 'path': '/terminals'},
      {'title': 'Categorías', 'icon': Icons.category, 'path': '/categories'},
      {'title': 'Payment Method', 'icon': Icons.credit_card, 'path': '/payment-methods'},
      {'title': 'Sales', 'icon': Icons.receipt_long, 'path': '/sales-history'},
      {'title': 'Products', 'icon': Icons.inventory, 'path': '/products'},
      {'title': 'Users', 'icon': Icons.manage_accounts, 'path': '/users'},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent, // Deja ver el DesktopScaffold u otro fondo
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/sales'),
          tooltip: 'Volver a Ventas',
        ),
        title: Text(
          'Configuración y Útiles',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 32.0),
            child: PosUserMenu(isRightSide: true),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel de Administración',
              style: AppTextStyles.w500(color: colorScheme.onSurfaceVariant, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 1.0,
                ),
                itemCount: utilityItems.length,
                itemBuilder: (context, index) {
                  final item = utilityItems[index];

                  return InkWell(
                    onTap: () {
                      final allowedPaths = ['/roles', '/users', '/payment-methods', '/products', '/restaurants', '/terminals', '/categories'];
                      if (allowedPaths.contains(item['path'])) {
                        context.go(item['path']);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Configuración para ${item['title']} - En construcción')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surfaceTint.withValues(alpha: 0.1) : Colors.white,
                        border: Border.all(
                          color: isDark ? colorScheme.outlineVariant : Colors.black12,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'],
                              size: 36,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item['title'],
                            style: AppTextStyles.bold(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
