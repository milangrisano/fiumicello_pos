import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/view/bar_view.dart';
import 'package:responsive_app/view/delivery_view.dart';
import 'package:responsive_app/view/tables_view.dart';
import 'package:responsive_app/view/takeaway_view.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            child: Material(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              elevation: 2,
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isDark ? AppColors.goldDark : AppColors.buttonGreenLight,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: isDark ? Colors.black87 : Colors.white,
                unselectedLabelColor: isDark ? Colors.white : AppColors.primaryTextLight,
                labelStyle: AppTextStyles.bold(fontSize: 18),
                unselectedLabelStyle: AppTextStyles.w500(fontSize: 18),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                tabs: const [
                  Tab(text: 'Para Llevar'),
                  Tab(text: 'Domicilios'),
                  Tab(text: 'Mesas'),
                  Tab(text: 'Barra'),
                ],
              ),
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                TakeawayView(),
                DeliveryPage(),
                TablesPage(),
                BarPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
