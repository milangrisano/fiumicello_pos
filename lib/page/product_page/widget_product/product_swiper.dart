import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/page/product_page/widget_product/product_grid.dart'; // Para reutilizar ProductCard
import 'package:responsive_app/configure/app_colors.dart';

class ProductSwiper extends StatefulWidget {
  final String category;
  final List<LandingMenuItem> items;
  final ValueChanged<String>? onCategoryChange;

  const ProductSwiper({
    super.key,
    required this.category,
    required this.items,
    this.onCategoryChange,
  });

  @override
  State<ProductSwiper> createState() => _ProductSwiperState();
}

class _ProductSwiperState extends State<ProductSwiper> {
  late final SwiperController _swiperController;
  bool _isAnimatingProgrammatically = false;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  void didUpdateWidget(covariant ProductSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category) {
      _scrollToCategory(widget.category);
    }
  }

  void _scrollToCategory(String categoryName) async {
    // Buscar el primer elemento de la categoría para movernos allí
    final index = widget.items.indexWhere((item) => item.category == categoryName);
    if (index != -1) {
      _isAnimatingProgrammatically = true;
      await _swiperController.move(index, animation: true);
      
      // Delay para evitar actualizaciones de índice mientras anima
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() { _isAnimatingProgrammatically = false; });
        }
      });
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text("No items available"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Swiper(
                controller: _swiperController,
                itemBuilder: (BuildContext context, int index) {
                  // Instanciamos el ProductCard con proporciones personalizadas:
                  // 3/4 (flex = 3) para la imagen, 1/4 (flex = 1) para text
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0, top: 10.0),
                    child: ProductCard(
                      item: widget.items[index],
                      imageFlex: 3,
                      textFlex: 1,
                    ),
                  );
                },
                itemCount: widget.items.length,
                viewportFraction: 0.5,
                scale: 0.8,
                loop: true,
                onIndexChanged: (index) {
                  if (_isAnimatingProgrammatically) return;
                  if (widget.onCategoryChange != null) {
                    final currentItemCategory = widget.items[index].category;
                    if (currentItemCategory != widget.category) {
                      widget.onCategoryChange!(currentItemCategory);
                    }
                  }
                },
                pagination: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                            color: AppColors.goldLightDark,
                            onPressed: () {
                              _swiperController.previous();
                            },
                          ),
                          const SizedBox(width: 8),
                          // Puntos de paginación estándar integrados
                          DotSwiperPaginationBuilder(
                            activeColor: AppColors.goldLightDark,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ).build(context, config),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            color: AppColors.goldLightDark,
                            onPressed: () {
                              _swiperController.next();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
