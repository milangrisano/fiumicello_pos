import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/shared/theme_provider.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/shared/login_modal.dart';
import 'package:go_router/go_router.dart';

class MobileScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const MobileScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _MobileAppBar(),
      body: body ?? LandingPage(category: category),
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MobileAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(60);

  void _openLoginModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LoginModal(
        onSuccess: () {
          Navigator.of(context).pop();
          context.go('/sales');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                context.watch<ThemeProvider>().isDarkMode 
                  ? Icons.light_mode_outlined 
                  : Icons.dark_mode_outlined,
                color: Theme.of(context).colorScheme.primary, 
                size: 20
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                  LandingStrings.fiumicelloLogo,
                  style: AppTextStyles.text(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                    weight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => _openLoginModal(context),
                child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.goldDark),
              ),
              child: const Icon(Icons.login, color: AppColors.goldDark, size: 18),
            ),
          ),
            ],
          ),
        ],
      ),
    );
  }
}
