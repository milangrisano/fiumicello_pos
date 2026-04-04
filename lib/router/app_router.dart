import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/sales_pages/sales_page.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/page/utilities_page/utilities_page.dart';
import 'package:responsive_app/page/utilities_page/roles_page.dart';
import 'package:responsive_app/page/utilities_page/users_page.dart';
import 'package:responsive_app/page/utilities_page/payment_methods_page.dart';
import 'package:responsive_app/page/utilities_page/products_page.dart';
import 'package:responsive_app/page/utilities_page/restaurants_page.dart';
import 'package:responsive_app/page/utilities_page/terminals_page.dart';
import 'package:responsive_app/page/utilities_page/categories_page.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';
import 'package:responsive_app/provider/auth_provider.dart';

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
      return '/';
    }

    // Si intenta entrar a /sales y SÍ tiene token local, confiamos en la validez
    // Si la llamada GET del backend lanza 401, el provider expulsará la sesión.

    // En cualquier otro caso (cualquier otra ruta, o ruta permitida), déjalo pasar
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(),
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: CartPage()),
      ),
    ),
    GoRoute(
      path: '/sales',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: SalesPage()),
      ),
    ),
    GoRoute(
      path: '/utilities',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: UtilitiesPage()),
      ),
    ),
    GoRoute(
      path: '/roles',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: RolesPage()),
      ),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: UsersPage()),
      ),
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: PaymentMethodsPage()),
      ),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: ProductsPage()),
      ),
    ),
    GoRoute(
      path: '/restaurants',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: RestaurantsPage()),
      ),
    ),
    GoRoute(
      path: '/terminals',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: TerminalsPage()),
      ),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: CategoriesPage()),
      ),
    ),
  ],
);
