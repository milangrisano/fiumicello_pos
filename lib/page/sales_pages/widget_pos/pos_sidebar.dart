import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';

class PosSidebar extends StatelessWidget {
  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onCategorySelected;

  const PosSidebar({
    super.key,
    required this.categories,
    required this.activeCategory,
    required this.onCategorySelected,
  });

  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'todos':
        return Icons.format_list_bulleted;
      case 'antipasti':
        return Icons.tapas;
      case 'primi':
        return Icons.ramen_dining;
      case 'secondi':
        return Icons.set_meal;
      case 'contorni':
        return Icons.restaurant;
      case 'pizzas':
        return Icons.local_pizza;
      case 'lasagnas':
        return Icons.layers; 
      case 'paninis':
        return Icons.bakery_dining;
      case 'postres':
      case 'dolci':
        return Icons.cake;
      case 'bebidas':
      case 'drinks':
        return Icons.local_drink;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: isDark ? colorScheme.outlineVariant : Colors.black12,
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
              'assets/images/fiumicello_hat.png',
              height: 60,
            ),
          Divider(height: 30, thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == activeCategory;
            
                return GestureDetector(
                  onTap: () => onCategorySelected(cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? colorScheme.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForCategory(cat),
                          size: 32,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w500(
                            fontSize: 12,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const PosUserMenu(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
