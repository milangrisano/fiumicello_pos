import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/shared/product_grid.dart'; // Para reutilizar ProductCard
import 'package:responsive_app/shared/app_colors.dart';

class ProductSwiper extends StatelessWidget {
  final List<LandingMenuItem> items;
  const ProductSwiper({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("No items available"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  // Instanciamos el ProductCard con proporciones personalizadas:
                  // 3/4 (flex = 3) para la imagen, 1/4 (flex = 1) para text
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0, top: 10.0),
                    child: ProductCard(
                      item: items[index],
                      imageFlex: 3,
                      textFlex: 1,
                    ),
                  );
                },
                itemCount: items.length,
                viewportFraction: 0.5,
                scale: 0.8,
                loop: true,
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
                              config.controller.previous();
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
                              config.controller.next();
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
