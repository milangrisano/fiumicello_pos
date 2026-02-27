import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';

import 'package:responsive_app/shared/product_grid.dart';
import 'package:responsive_app/shared/category_pills.dart';
import 'package:responsive_app/shared/product_swiper.dart'; // Import del nuevo swiper

// ─────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────
import 'package:responsive_app/content/content_landing.dart';


// ─────────────────────────────────────────
// Landing Page
// ─────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Option 'Todos' removed, defaulting to the first category
  String _selectedCategory = landingCategories.isNotEmpty ? landingCategories.first.name : ''; 
  bool _showGrid = true; // Controla que vista se muestra

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
                onSelect: (c) => setState(() => _selectedCategory = c),
              ),
              Expanded(
                child: _showGrid 
                  ? ProductGrid(
                      category: _selectedCategory,
                      items: _orderedItems, // Update to use ordered items
                      onCategoryChange: (newCategory) {
                        if (_selectedCategory != newCategory) {
                          setState(() => _selectedCategory = newCategory);
                        }
                      },
                    )
                  : ProductSwiper(
                      category: _selectedCategory,
                      items: _orderedItems, // Update to use ordered items
                      onCategoryChange: (newCategory) {
                        if (_selectedCategory != newCategory) {
                          setState(() => _selectedCategory = newCategory);
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
                // TODO: Acción del carrito
              },
              child: const Icon(Icons.shopping_cart_outlined), 
            ),
          ),
        ],
      ),
    );
  }
}
