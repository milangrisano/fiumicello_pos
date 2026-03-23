import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

// ─────────────────────────────────────────
// Category Pills
// ─────────────────────────────────────────
class CategoryPills extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const CategoryPills({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          final isSelected = cat == selected;

          Color bgColor = Colors.transparent;
          Color borderColor = colorScheme.onSurface;
          Color textColor = colorScheme.onSurface;

          if (isSelected) {
            bgColor = Theme.of(context).colorScheme.surface;
            borderColor = Theme.of(context).colorScheme.primary;
            textColor = Theme.of(context).colorScheme.primary;
          }

          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Text(
                cat,
                style: AppTextStyles.text(
                  color: textColor,
                  fontSize: 14,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
