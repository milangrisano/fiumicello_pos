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
        // Determinamos un ancho máximo para mantener las proporciones 
        // de la carta parecidas al grid y que no se estire demasiado a lo ancho
        final cardWidth = constraints.maxWidth * 0.72;

        return Column(
          children: [
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  // Instanciamos el ProductCard con proporciones personalizadas:
                  // 3/4 (flex = 3) para la imagen, 1/4 (flex = 1) para text
                  return ProductCard(
                    item: items[index],
                    imageFlex: 3,
                    textFlex: 1,
                  );
                },
                itemCount: items.length,
                itemWidth: cardWidth,
                itemHeight: cardWidth * 0.8,
                layout: SwiperLayout.STACK,
                loop: true,
                pagination: const SwiperPagination(
                  margin: EdgeInsets.only(top: 20), // Margen para sacarlos de la caja de la carta
                  builder: DotSwiperPaginationBuilder(
                    activeColor: AppColors.goldLightDark,
                    color: AppColors.mutedTextLight,
                  ),
                ),
                control: const SwiperControl(
                  color: AppColors.goldLightDark,
                  size: 30,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }
    );
  }
}
