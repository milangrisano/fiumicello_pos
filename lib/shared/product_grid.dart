import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/shared/button_card.dart';
import 'package:responsive_app/content/content_landing.dart';

// ─────────────────────────────────────────
// Product Grid
// ─────────────────────────────────────────
class ProductGrid extends StatelessWidget {
  final String category;
  final List<LandingMenuItem> items;
  const ProductGrid({super.key, required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    // Si la categoría dada es 'Todos', agrupamos por tipo de comida
    final isAll = category == 'Todos';
    
    // Agrupar elementos por categoría respetando el orden original
    final Map<String, List<LandingMenuItem>> groupedItems = {};
    if (isAll) {
      for (final cat in landingCategories) {
        final catItems = items.where((item) => item.category == cat.name).toList();
        if (catItems.isNotEmpty) {
          groupedItems[cat.name] = catItems;
        }
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.mutedTextLight),
        ),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 6.0,
        radius: const Radius.circular(10),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: isAll 
            ? _buildGroupedGrids(groupedItems)
            : _buildSingleGrid(category, items),
        ),
      ),
    );
  }

  /// Construye un bloque individual de cuadrículas (la vista tradicional)
  List<Widget> _buildSingleGrid(String title, List<LandingMenuItem> gridItems) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Builder(
          builder: (context) {
            return Text(
              title,
              style: AppTextStyles.text(
                fontSize: 24,
                weight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          }
        ),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: gridItems.length,
        itemBuilder: (_, i) => ProductCard(item: gridItems[i]),
      ),
    ];
  }

  /// Construye múltiples bloques de cuadrículas dependiendo de sus categorías
  List<Widget> _buildGroupedGrids(Map<String, List<LandingMenuItem>> groupedData) {
    final List<Widget> children = [];
    
    groupedData.forEach((catName, catItems) {
      // Por cada grupo agregar su título y grid pertinente
      children.addAll(_buildSingleGrid(catName, catItems));
      
      // Separación visual entre categorías distintas
      children.add(const SizedBox(height: 32));
    });

    return children;
  }
}

// ─────────────────────────────────────────
// Product Card
// ─────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final LandingMenuItem item;
  final int imageFlex;
  final int textFlex;

  const ProductCard({
    super.key, 
    required this.item,
    this.imageFlex = 2,
    this.textFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.goldLightDark,
          width: 2.0
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen 
          Expanded(
            flex: imageFlex,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: item.plateColor.withValues(alpha: 0.18),
                    child: Center(
                      child: Icon(Icons.restaurant, size: 56, color: item.plateColor.withValues(alpha: 0.85)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Textos 
          Expanded(
            flex: textFlex,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text(
                      fontSize: 13,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.text(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.price,
                    style: AppTextStyles.text(
                      fontSize: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ButtonCard(
                    text: LandingStrings.btnAddToCart,
                    onPressed: () {},
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
