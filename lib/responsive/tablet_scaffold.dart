import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/shared/theme_provider.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/shared/login_modal.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _TabletAppBar(),
      body: const LandingPage(),
    );
  }
}

class _TabletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TabletAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      toolbarHeight: 70,
      titleSpacing: 20,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                context.watch<ThemeProvider>().isDarkMode 
                  ? Icons.light_mode_outlined 
                  : Icons.dark_mode_outlined,
                color: Theme.of(context).colorScheme.primary, 
                size: 22
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(
                    LandingStrings.fiumicelloLogo,
                    style: AppTextStyles.text(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                      weight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 30, height: 1, color: AppColors.secondaryTextLight),
                    const SizedBox(width: 8),
                    Text(
                      LandingStrings.estYear, 
                      style: AppTextStyles.text(
                        fontSize: 10, 
                        color: AppColors.secondaryTextLight
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 30, height: 1, color: AppColors.secondaryTextLight),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _openLoginModal(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: AppColors.surfaceDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.goldDark),
              ),
            ),
            child: Text(
              'Iniciar',
              style: AppTextStyles.w500(
                color: AppColors.goldDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}