import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class ListTileProduct extends StatelessWidget {
  final List<CartItemModel> items;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onRemove;

  const ListTileProduct({
    required this.items,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Text(
          "El carrito está vacío",
          style: AppTextStyles.w500(fontSize: 18, color: AppColors.secondaryTextLight),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.goldHighlightDark),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.bold(fontSize: 18, color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: AppTextStyles.text(fontSize: 13, color: isDark ? Colors.white : Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.price,
                      style: AppTextStyles.bold(fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Actions
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _CircleBtn(icon: Icons.remove, onTap: () => onDecrement(index)),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: AppTextStyles.w500(fontSize: 16, color: isDark ? AppColors.goldHighlightDark : Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      _CircleBtn(icon: Icons.add, onTap: () => onIncrement(index)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onRemove(index),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: isDark ? AppColors.goldHighlightDark : Colors.black54),
                          const SizedBox(width: 4),
                          Text(
                            LandingStrings.btnDelete,
                            style: AppTextStyles.w500(fontSize: 14, color: isDark ? AppColors.goldHighlightDark : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? AppColors.goldHighlightDark :  Colors.black26),
        ),
        child: Icon(icon, size: 16, color: isDark ? AppColors.goldHighlightDark : Colors.black87),
      ),
    );
  }
}