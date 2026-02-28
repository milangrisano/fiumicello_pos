import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/shared/login_modal.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/shared/theme_provider.dart';
import 'package:go_router/go_router.dart';

class DesktopScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const DesktopScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _DesktopAppBar(),
      body: body ?? LandingPage(category: category),
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
      toolbarHeight: 80,
      titleSpacing: 24,
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
            child: Image.asset(
              'assets/images/fiumicello_hat.png',
              height: 60,
            ),
          ),
          const SizedBox(width: 8),
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
              'Iniciar sesión',
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
