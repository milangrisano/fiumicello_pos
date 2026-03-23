import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/product.dart';
import 'package:intl/intl.dart';

class PosGridItem {
  final String name;
  final Product? singleProduct;
  final Map<String, Product> variants;

  PosGridItem({
    required this.name,
    this.singleProduct,
    this.variants = const {},
  });
}

class PosProductGrid extends StatelessWidget {
  final String category;
  final List<Product> products;
  final Function(Product) onAddProduct;
  final String searchQuery;

  const PosProductGrid({
    super.key,
    required this.category,
    required this.products,
    required this.onAddProduct,
    this.searchQuery = '',
  });

  static const List<String> _sizeOrder = ['Personal', 'Mediana', 'Grande', 'Familiar'];

  List<PosGridItem> _groupProducts(String catName, List<Product> catProducts) {
    if (catName.toLowerCase() == 'pizzas') {
      final Map<String, List<Product>> grouped = {};
      
      for (final p in catProducts) {
        grouped.putIfAbsent(p.name, () => []).add(p);
      }

      final List<PosGridItem> items = [];
      for (final entry in grouped.entries) {
        final variantsList = entry.value;
        if (variantsList.length > 1 || variantsList.first.category.toLowerCase() == 'pizzas') {
          variantsList.sort((a, b) {
            final indexA = _sizeOrder.indexOf(a.type);
            final indexB = _sizeOrder.indexOf(b.type);
            return (indexA == -1 ? 99 : indexA)
                .compareTo(indexB == -1 ? 99 : indexB);
          });
  
          final Map<String, Product> variants = {};
          for (final v in variantsList) {
            variants[v.type.isNotEmpty ? v.type : 'Unico'] = v;
          }
  
          items.add(PosGridItem(
            name: variantsList.first.name,
            variants: variants,
          ));
        } else {
             items.add(PosGridItem(name: variantsList.first.name, singleProduct: variantsList.first));
        }
      }
      return items;
    } else {
      return catProducts
          .map((p) => PosGridItem(name: p.name, singleProduct: p))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> displayProducts = products;
    bool isGlobalSearch = searchQuery.trim().isNotEmpty;

    if (isGlobalSearch) {
      final queryLower = searchQuery.trim().toLowerCase();
      displayProducts = products.where((p) {
        return p.name.toLowerCase().contains(queryLower) ||
               p.type.toLowerCase().contains(queryLower) ||
               p.category.toLowerCase().contains(queryLower);
      }).toList();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark
          ? colorScheme.surface.withValues(alpha: 0.5)
          : const Color(0xFFF9F9F9),
      padding: const EdgeInsets.all(24),
      child: (category.toLowerCase() == 'todos' || isGlobalSearch)
          ? _buildAllCategories(context, colorScheme, displayProducts)
          : _buildSingleCategory(context, colorScheme, category, displayProducts.where((item) => item.category == category).toList()),
    );
  }

  Widget _buildAllCategories(BuildContext context, ColorScheme colorScheme, List<Product> displayProducts) {
    final List<String> sortedCats = displayProducts.map((p) => p.category).toSet().toList();

    if (displayProducts.isEmpty) {
      return Center(
        child: Text(
          'No hay coincidencias de busqueda',
          style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      itemCount: sortedCats.length,
      itemBuilder: (context, index) {
        final catName = sortedCats[index];
        final catProducts = displayProducts.where((p) => p.category == catName).toList();
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: _buildCategorySection(context, colorScheme, catName, catProducts, isAllView: true),
        );
      },
    );
  }

  Widget _buildSingleCategory(BuildContext context, ColorScheme colorScheme, String catName, List<Product> catProducts) {
    if (catProducts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(colorScheme, catName, 0),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                'No hay productos en esta categoría',
                style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        ],
      );
    }

    if (catName.toLowerCase() == 'bebidas' || catName.toLowerCase() == 'drinks') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(colorScheme, catName, _groupProducts(catName, catProducts).length),
          const SizedBox(height: 24),
          Expanded(child: _buildSubdividedGrid(catName, catProducts, colorScheme, isScrollable: true)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryHeader(colorScheme, catName, _groupProducts(catName, catProducts).length),
        const SizedBox(height: 24),
        Expanded(
          child: _buildGrid(catName, catProducts),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context, ColorScheme colorScheme, String catName, List<Product> catProducts, {bool isAllView = false}) {
    if (catName.toLowerCase() == 'bebidas' || catName.toLowerCase() == 'drinks') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(colorScheme, catName, _groupProducts(catName, catProducts).length),
          const SizedBox(height: 24),
          _buildSubdividedGrid(catName, catProducts, colorScheme, isScrollable: false),
        ],
      );
    }

    final gridItems = _groupProducts(catName, catProducts);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryHeader(colorScheme, catName, gridItems.length),
        const SizedBox(height: 24),
        _buildGrid(catName, catProducts, shrinkWrap: isAllView),
      ],
    );
  }

  Widget _buildSubdividedGrid(String catName, List<Product> catProducts, ColorScheme colorScheme, {bool isScrollable = false}) {
    final Map<String, List<Product>> byType = {};
    for (var p in catProducts) {
      final t = p.type.trim().isEmpty ? 'Variedades' : p.type.trim();
      byType.putIfAbsent(t, () => []).add(p);
    }

    final sortedTypes = byType.keys.toList()..sort();
    
    final List<Widget> sections = [];
    for (var i = 0; i < sortedTypes.length; i++) {
      final type = sortedTypes[i];
      final typeProducts = byType[type]!;
      final displayType = type[0].toUpperCase() + type.substring(1).toLowerCase();
      final gridItems = _groupProducts(catName, typeProducts);

      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayType,
                style: AppTextStyles.bold(fontSize: 18, color: colorScheme.onSurface),
              ),
              Text(
                '${gridItems.length} items',
                style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );

      sections.add(
        Padding(
          padding: EdgeInsets.only(bottom: i == sortedTypes.length - 1 ? 0 : 32.0),
          child: _buildGrid(catName, typeProducts, shrinkWrap: true),
        ),
      );
    }

    if (isScrollable) {
      return ListView(
        padding: EdgeInsets.zero,
        children: sections,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections,
      );
    }
  }

  Widget _buildCategoryHeader(ColorScheme colorScheme, String catName, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          catName,
          style: AppTextStyles.bold(
            fontSize: 24,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          '$itemCount items',
          style: AppTextStyles.text(
            color: colorScheme.onSurfaceVariant,
          ),
        )
      ],
    );
  }

  Widget _buildGrid(String catName, List<Product> catProducts, {bool shrinkWrap = false}) {
    final gridItems = _groupProducts(catName, catProducts);
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.82,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        return PosProductCard(
          item: gridItems[index],
          onAdd: onAddProduct,
        );
      },
    );
  }
}

class PosProductCard extends StatelessWidget {
  final PosGridItem item;
  final Function(Product) onAdd;

  const PosProductCard({super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final numberFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colorScheme.outlineVariant : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                'assets/images/fiumicello_hat.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.orange.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(Icons.restaurant,
                        size: 48, color: Colors.orange),
                  ),
                ),
              ),
            ),
          ),
          // Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.w500(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  if (item.variants.isNotEmpty)
                    _buildSizeVariants(context, numberFormat)
                  else
                    _buildSinglePrice(context, numberFormat),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePrice(BuildContext context, NumberFormat format) {
    if (item.singleProduct == null) return const SizedBox.shrink();
    final p = item.singleProduct!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          format.format(p.price),
          style: AppTextStyles.bold(
            fontSize: 13,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => onAdd(p),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'AGREGAR',
                textAlign: TextAlign.center,
                style: AppTextStyles.bold(
                  fontSize: 10,
                  color: colorScheme.primary, // Dorado primary
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeVariants(BuildContext context, NumberFormat format) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: item.variants.entries.map((entry) {
        final variantName = entry.key;
        final product = entry.value;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  format.format(product.price),
                  style: AppTextStyles.bold(
                    fontSize: 11,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => onAdd(product),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        variantName,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold(
                          fontSize: 10,
                          color: colorScheme.primary, // Dorado primary
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

