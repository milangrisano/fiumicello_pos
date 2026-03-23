import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/provider/auth_provider.dart';
import 'package:responsive_app/shared/dark_ligth_button.dart';
import 'package:responsive_app/shared/logout_button.dart';

//NOTA: No esta siendo utilizado en ningun lado
class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

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
          DarkAndLightButton(),
          Expanded(
            child: Image.asset(
              'assets/images/fiumicello_hat.png',
              height: 60,
            ),
          ),
          const SizedBox(width: 8),
          // Only show 'Iniciar sesión' button if we are NOT on the landing page ('/')
          // But actually we can just check authentication status
          if (!context.watch<AuthProvider>().isAuthenticated &&
              GoRouterState.of(context).uri.path != '/')
            LoginButton(onPressed: () {
              context.go('/');
            },)
          else if (context.watch<AuthProvider>().isAuthenticated)
            LogoutButton(onPressed: () {
              final auth = context.read<AuthProvider>();
              // Primero redireccionamos a una ruta no protegida (home)
              context.go('/');
              // Despues de cambiar la ruta, entonces sí borramos la sesión
              Future.microtask(() => auth.logout());
            },)
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side:
              BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: Text(
        'Iniciar sesión',
        style: AppTextStyles.w500(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}