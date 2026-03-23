import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/pos_order.dart';

class PosBottomBar extends StatelessWidget {
  final List<PosOrder> openOrders;
  final int? selectedIndex;
  final ValueChanged<int?> onSelected;

  const PosBottomBar({
    super.key,
    required this.openOrders,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? colorScheme.outlineVariant : Colors.black12,
            width: 2,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: openOrders.length,
        itemBuilder: (context, index) {
          final orderIndex = index;
          final order = openOrders[orderIndex];
          final isSelected = orderIndex == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(orderIndex),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: colorScheme.primary)
                    : Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    order.id,
                    style: AppTextStyles.bold(
                      fontSize: 16,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.name,
                    style: AppTextStyles.w500(
                      fontSize: 14,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
