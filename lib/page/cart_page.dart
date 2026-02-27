import 'package:flutter/material.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';
import 'package:responsive_app/view/cart_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileScaffold(body: CartView()),
      tabletScaffold: TabletScaffold(body: CartView()),
      desktopScaffold: DesktopScaffold(body: CartView()),
    );
  }
}
