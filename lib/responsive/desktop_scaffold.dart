import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/shared/login_modal.dart';
import 'package:responsive_app/content/content_landing.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _DesktopAppBar(),
      body: LandingPage(),
    );
  }
}

class _DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DesktopAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(80);

  void _openLoginModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LoginModal(
        onSuccess: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => const SalesPage(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 24,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _openLoginModal(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.person, color: AppColors.goldDark, size: 22),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LandingStrings.fiumicelloLogo,
                  style: AppTextStyles.text(
                    fontSize: 38,
                    color: AppColors.primaryTextLight,
                    weight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 40, height: 1, color: AppColors.secondaryTextLight),
                    const SizedBox(width: 8),
                    Text(
                      LandingStrings.estYear, 
                      style: AppTextStyles.text(
                        fontSize: 10, 
                        color: AppColors.secondaryTextLight
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 1, color: AppColors.secondaryTextLight),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.shopping_cart_outlined, color: AppColors.goldDark, size: 22),
          ),
        ],
      ),
    );
  }
}
