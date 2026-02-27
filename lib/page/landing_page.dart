import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';

import 'package:responsive_app/shared/product_grid.dart';
import 'package:responsive_app/shared/category_pills.dart';
import 'package:responsive_app/shared/product_swiper.dart'; // Import del nuevo swiper
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────
import 'package:responsive_app/content/content_landing.dart';


// ─────────────────────────────────────────
// Landing Page
// ─────────────────────────────────────────
class LandingPage extends StatefulWidget {
  final String? category;
  const LandingPage({super.key, this.category});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late String _selectedCategory;
  bool _showGrid = true; // Controla que vista se muestra

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? (landingCategories.isNotEmpty ? landingCategories.first.name : ''); 
  }

  @override
  void didUpdateWidget(LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != null && widget.category != _selectedCategory) {
      if (landingCategories.any((c) => c.name == widget.category)) {
         _selectedCategory = widget.category!;
      }
    } else if (widget.category == null && landingCategories.isNotEmpty && _selectedCategory != landingCategories.first.name) {
       _selectedCategory = landingCategories.first.name;
    }
  }

  List<String> get _displayCategories =>
      landingCategories.map((c) => c.name).toList();

  List<LandingMenuItem> get _orderedItems {
    final List<LandingMenuItem> ordered = [];
    for (final cat in landingCategories) {
      ordered.addAll(landingMenuItems.where((m) => m.category == cat.name));
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              CategoryPills(
                categories: _displayCategories,
                selected: _selectedCategory,
                onSelect: (c) {
                  if (_selectedCategory != c) {
                    context.go('/$c');
                  }
                },
              ),
              Expanded(
                child: _showGrid 
                  ? ProductGrid(
                      category: _selectedCategory,
                      items: _orderedItems, // Update to use ordered items
                      onCategoryChange: (newCategory) {
                        if (_selectedCategory != newCategory) {
                          context.go('/$newCategory');
                        }
                      },
                    )
                  : ProductSwiper(
                      category: _selectedCategory,
                      items: _orderedItems, // Update to use ordered items
                      onCategoryChange: (newCategory) {
                        if (_selectedCategory != newCategory) {
                          context.go('/$newCategory');
                        }
                      },
                    ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: FloatingActionButton(
              heroTag: 'view_toggle_fab',
              backgroundColor: AppColors.primaryTextLight,
              foregroundColor: AppColors.goldDark,
              onPressed: () {
                setState(() {
                  _showGrid = !_showGrid; // Cambiar tipo de vista
                });
              },
              child: Icon(_showGrid ? Icons.layers : Icons.grid_view), 
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              heroTag: 'cart_fab',
              backgroundColor: AppColors.primaryTextLight,
              foregroundColor: AppColors.goldDark,
              onPressed: () {
                context.go('/cart');
              },
              child: const Icon(Icons.shopping_cart_outlined), 
            ),
          ),
        ],
      ),
    );
  }
}
