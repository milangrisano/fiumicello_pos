import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/view/takeaway_view.dart';
import '../view/delivery_view.dart';
import '../view/tables_view.dart';
import '../view/bar_view.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            color: AppColors.backgroundDark,
            child: Material(
              color: AppColors.backgroundDark,
              elevation: 2,
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.goldDark,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.white,
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
