import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';
import 'package:responsive_app/shared/auth_provider.dart';
import 'package:responsive_app/shared/login_modal.dart';

// Definimos una clave global para el Navigator, para poder mostrar dialogos
// desde fuera de un widget específico (o usarla en redirecciones diferidas)
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  // Le decimos a GoRouter que recalcule las rutas cuando el AuthProvider notifique cambios (Login/Logout)
  refreshListenable: AuthProvider.instance,
  redirect: (context, state) async {
    final isGoingToSales = state.uri.path == '/sales';
    final auth = AuthProvider.instance;

    // Si el usuario intenta entrar a /sales pero no tiene un token JWT guardado
    if (isGoingToSales && !auth.isAuthenticated) {
      // Diferimos el pintado del Dialog al siguiente frame de UI usando addPostFrameCallback
      // para evitar errores por intentar pintar dialogs durante la fase de 'build' de GoRouter.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final overlayContext = rootNavigatorKey.currentState?.overlay?.context;
        if (overlayContext != null) {
          showDialog(
            context: overlayContext,
            barrierColor: Colors.black54,
            builder: (_) => LoginModal(
              onSuccess: () {
                // Cerramos el modal
                Navigator.of(overlayContext).pop();
                // Simplemente notificamos el login en nuestro proveedor para que 
                // GoRouter automáticamente re-evalúe la ruta /sales y conceda permisos
                auth.login("simulated_jwt_token");
              }
            ),
          );
        }
      });
      // Lo redirigimos a home por el momento (pero con el Modal abierto encima)
      return '/'; 
    }

    // Si intenta entrar a /sales y SÍ tiene token local, validamos con el Backend
    // (Esto es opcional si solo quieres validar en el login, pero lo solicitaste expresamente)
    if (isGoingToSales && auth.isAuthenticated) {
      final isValid = await auth.verifyTokenWithBackend();
      if (!isValid) {
        // El Backend dice que el JWT es inválido o expiró
        auth.logout(); // Limpiamos el token local
        return '/'; // Lo pateamos al inicio
      }
    }

    // En cualquier otro caso (cualquier otra ruta, o ruta permitida), déjalo pasar
    return null; 
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: CartPage()),
        tabletScaffold: TabletScaffold(body: CartPage()),
        desktopScaffold: DesktopScaffold(body: CartPage()),
      ),
    ),
    GoRoute(
      path: '/sales',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: SalesPage()),
        tabletScaffold: TabletScaffold(body: SalesPage()),
        desktopScaffold: DesktopScaffold(body: SalesPage()),
      ),
    ),
    GoRoute(
      path: '/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'];
        if (category == 'sales') {
          return const SalesPage();
        }
        return ResponsiveLayout(
          mobileScaffold: MobileScaffold(category: category),
          tabletScaffold: TabletScaffold(category: category),
          desktopScaffold: DesktopScaffold(category: category),
        );
      },
    ),
  ],
);
