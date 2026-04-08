import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/sales_pages/sales_page.dart';
import 'package:responsive_app/page/sales_pages/floor_plan_page.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/page/guest_page/guest_page.dart';
import 'package:responsive_app/page/utilities_page/utilities_page.dart';
import 'package:responsive_app/page/utilities_page/roles_page.dart';
import 'package:responsive_app/page/utilities_page/users_page.dart';
import 'package:responsive_app/page/utilities_page/payment_methods_page.dart';
import 'package:responsive_app/page/utilities_page/products_page.dart';
import 'package:responsive_app/page/utilities_page/restaurants_page.dart';
import 'package:responsive_app/page/utilities_page/terminals_page.dart';
import 'package:responsive_app/page/utilities_page/categories_page.dart';
import 'package:responsive_app/page/utilities_page/sales_history_page.dart';
import 'package:responsive_app/page/utilities_page/kitchen_display_page.dart';
import 'package:responsive_app/page/utilities_page/tables_page.dart';
import 'package:responsive_app/page/utilities_page/global_sales_stats_page.dart';
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
    final auth = AuthProvider.instance;
    final currentPath = state.uri.path;

    // Si el usuario no está autenticado y va a rutas protegidas, redirigir a home
    if (!auth.isAuthenticated && currentPath != '/') {
      return '/';
    }

    // Si el usuario está autenticado
    if (auth.isAuthenticated && auth.currentUser != null) {
      final user = auth.currentUser!;
      final isGuest = user.isGuestUser;

      if (isGuest) {
        // Redirigir SIEMPRE al guest si no está en guest
        if (currentPath != '/guest') {
          return '/guest';
        }
      } else {
        // Validaciones finas por permisos
        
        // Kitchen access
        if (currentPath == '/kitchen' && !user.hasPermission('kitchen:view')) {
          return '/sales'; // Fallback to sales
        }
        
        // Utilities access
        if (currentPath.startsWith('/utilities') || 
            currentPath == '/roles' || 
            currentPath == '/users' || 
            currentPath == '/payment-methods' ||
            currentPath == '/products' ||
            currentPath == '/restaurants' ||
            currentPath == '/terminals' ||
            currentPath == '/categories' ||
            currentPath == '/sales-history' ||
            currentPath == '/global-stats') {
          // If they try to enter utilities without any access
          if (!user.hasPermission('utilities:access') && 
              !user.hasPermission('sales:view_history') && 
              !user.hasPermission('tables:manage')) {
            // First allowed fallback is Kitchen if they only have kitchen view
            if (user.hasPermission('kitchen:view')) return '/kitchen';
            return '/sales'; 
          }
        }
        
        // Tables manage
        if (currentPath == '/tables' && !user.hasPermission('tables:manage')) {
          if (user.hasPermission('kitchen:view')) return '/kitchen';
          return '/sales';
        }
        
        // Sales routing logic
        if (currentPath == '/' || currentPath == '/guest') {
          // Si el usuario tiene acceso a Ventas, que vaya a Ventas. Si no, pero a Kitchen sí, redirigir a Kitchen.
          if (user.hasPermission('sales:manage') || user.hasPermission('tables:view') || user.hasPermission('sales:manage_active_payments')) {
             return '/sales';
          } else if (user.hasPermission('kitchen:view')) {
             return '/kitchen';
          }
          return '/sales'; // Default assumption
        }
      }
    }

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
      path: '/guest',
      builder: (context, state) => const GuestPage(),
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
        desktopScaffold: const DesktopScaffold(body: FloorPlanPage()),
      ),
    ),
    GoRoute(
      path: '/sales/pos',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ResponsiveLayout(
          mobileScaffold: MobileScaffold(),
          tabletScaffold: TabletScaffold(),
          desktopScaffold: DesktopScaffold(body: SalesPage(
            orderParams: extra,
          )),
        );
      },
    ),
    GoRoute(
      path: '/sales-history',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: SalesHistoryPage()),
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
    GoRoute(
      path: '/kitchen',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: KitchenDisplayPage()),
      ),
    ),
    GoRoute(
      path: '/tables',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: TablesPage()),
      ),
    ),
    GoRoute(
      path: '/global-stats',
      builder: (context, state) => ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: const DesktopScaffold(body: GlobalSalesStatsPage()),
      ),
    ),
  ],
);
