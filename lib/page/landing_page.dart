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
  String _selectedCategory = 'Todos'; // Opción todos por defecto
  bool _showGrid = true; // Controla que vista se muestra

  List<LandingMenuItem> get _filtered =>
      _selectedCategory == 'Todos' 
          ? landingMenuItems 
          : landingMenuItems.where((m) => m.category == _selectedCategory).toList();

  List<String> get _displayCategories =>
      ['Todos', ...landingCategories.map((c) => c.name)];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
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
                      items: _filtered,
                    )
                  : ProductSwiper(
                      items: _filtered,
                    ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
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
        ],
      ),
    );
  }
}
