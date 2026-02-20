import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'takeaway_page.dart';
import 'delivery_page.dart';
import 'tables_page.dart';
import 'bar_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 2,
          toolbarHeight: 1,
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.gold,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.white,
            labelStyle: AppTextStyles.navLabel(fontSize: 18),
            unselectedLabelStyle: AppTextStyles.navLabelUnselected(fontSize: 18),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: const [
              Tab(text: 'Para Llevar'),
              Tab(text: 'Domicilios'),
              Tab(text: 'Mesas'),
              Tab(text: 'Barra'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TakeawayPage(),
            DeliveryPage(),
            TablesPage(),
            BarPage(),
          ],
        ),
      ),
    );
  }
}
