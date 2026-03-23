import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/page/buy_cart_page/widget_cart/list_tile_product.dart';
import 'package:responsive_app/page/buy_cart_page/widget_cart/order_sumary.dart';
import 'package:responsive_app/page/buy_cart_page/widget_cart/payment_method.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Estado local para los items del carrito simulados
  List<CartItemModel> items = List.from(mockCartItems);
  int _selectedPaymentMethod = 0;
  bool _isHoveringBack = false;

  void _increment(int index) {
    setState(() => items[index].quantity++);
  }

  void _decrement(int index) {
    if (items[index].quantity > 1) {
      setState(() => items[index].quantity--);
    }
  }

  void _remove(int index) {
    setState(() => items.removeAt(index));
  }

  double get subtotal {
    return items.fold(0, (sum, item) {
      final priceStr = item.product.price.replaceAll('\$', '');
      final price = double.tryParse(priceStr) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  double get tax => subtotal * 0.095; // 9.5% approx
  double get delivery => 5.0;
  double get total => items.isEmpty ? 0 : subtotal + tax + delivery;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isHoveringBack = true),
              onTapUp: (_) {
                setState(() => _isHoveringBack = false);
                context.go('/');
              },
              onTapCancel: () => setState(() => _isHoveringBack = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(
                    _isHoveringBack ? -5.0 : 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios,
                        size: 14, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      LandingStrings.btnBackToProducts,
                      style: AppTextStyles.w500(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LandingStrings.cartTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w500,
              color: isDark
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87, // O Theme.of(context).colorScheme.onSurface
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ListTileProduct(
                  items: items,
                  onIncrement: _increment,
                  onDecrement: _decrement,
                  onRemove: _remove,
                ),
              ),
              const SizedBox(width: 32),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    OrderSummary(
                        subtotal: subtotal,
                        tax: tax,
                        delivery: items.isEmpty ? 0 : delivery,
                        total: total),
                    const SizedBox(height: 24),
                    PaymentMethod(
                      selectedValue: _selectedPaymentMethod,
                      onChanged: (val) =>
                          setState(() => _selectedPaymentMethod = val ?? 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
