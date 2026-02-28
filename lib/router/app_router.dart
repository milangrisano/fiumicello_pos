import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/sales_page.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const SalesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
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
