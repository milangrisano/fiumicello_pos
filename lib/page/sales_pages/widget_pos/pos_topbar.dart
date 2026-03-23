import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class PosTopbar extends StatelessWidget {
  final bool isNewOrderSelected;
  final VoidCallback onSelectNewOrder;
  final ValueChanged<String> onSearchChanged;

  const PosTopbar({
    super.key,
    required this.isNewOrderSelected,
    required this.onSelectNewOrder,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? colorScheme.outlineVariant : Colors.black12,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: AppTextStyles.text(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  hintStyle:
                      AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                  prefixIcon:
                      Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Add Table Button positioned next to the search bar
          GestureDetector(
            onTap: onSelectNewOrder,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isNewOrderSelected ? colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isNewOrderSelected
                    ? Border.all(color: colorScheme.primary)
                    : Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: isNewOrderSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nueva Mesa',
                    style: AppTextStyles.w500(
                      fontSize: 14,
                      color: isNewOrderSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
