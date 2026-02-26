import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_products.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

class AddProductModal extends StatefulWidget {
  final String customerName;
  final String orderId;

  const AddProductModal({
    super.key,
    this.customerName = 'Cliente',
    this.orderId = '—',
  });

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductItem> get _filteredProducts {
    return productCatalog.where((p) {
      final matchesCategory =
          _selectedCategory == 'Todos' || p.category == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title + close
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
            child: Row(
              children: [
                Text('Agregar Producto',
                    style: AppTextStyles.w500(fontSize: 18)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Customer info row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                // Order number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.white38, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        '#${widget.orderId}',
                        style: AppTextStyles.text(fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Customer name + edit
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.white38, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.customerName,
                          style: AppTextStyles.w500(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.goldDark, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Editar cliente',
                        onPressed: () {
                          // TODO: editar nombre del cliente
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: AppTextStyles.text(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar producto…',
                hintStyle: AppTextStyles.text(fontSize: 14, color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white10,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Content: categories + products
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT — Category column
                SizedBox(
                  width: 110,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: productCategories.length,
                    itemBuilder: (_, i) {
                      final cat = productCategories[i];
                      final isSelected = cat.name == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.goldDark.withValues(alpha: 0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isSelected ? AppColors.goldDark : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                cat.icon,
                                color: isSelected
                                    ? AppColors.goldDark
                                    : Colors.white38,
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.name,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.text(
                                  fontSize: 11,
                                  color: isSelected
                                      ? AppColors.goldDark
                                      : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Vertical divider
                const VerticalDivider(color: Colors.white10, width: 1),

                // RIGHT — Products grid
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'Sin resultados',
                            style: AppTextStyles.text(
                                fontSize: 14, color: Colors.white38),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (_, i) {
                            final product = _filteredProducts[i];
                            return _ProductCard(product: product);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: añadir al pedido
          Navigator.of(context).pop(product);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                color: AppColors.goldDark.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(product.icon,
                    color: AppColors.goldDark, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text(fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                product.price,
                style: AppTextStyles.w500(
                    fontSize: 13, color: AppColors.goldDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
