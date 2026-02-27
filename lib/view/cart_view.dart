import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // Estado local para los items del carrito simulados
  List<CartItemModel> items = List.from(mockCartItems);
  int _selectedPaymentMethod = 0;

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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? size.width * 0.1 : 20,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.goldDark),
                  const SizedBox(width: 4),
                  Text(
                    LandingStrings.btnBackToProducts,
                    style: AppTextStyles.w500(fontSize: 14, color: AppColors.goldDark),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LandingStrings.cartTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w500,
              color: AppColors.primaryTextLight, // O Theme.of(context).colorScheme.onSurface
            ),
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _CartItemsList(
                    items: items,
                    onIncrement: _increment,
                    onDecrement: _decrement,
                    onRemove: _remove,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _OrderSummary(subtotal: subtotal, tax: tax, delivery: items.isEmpty ? 0 : delivery, total: total),
                      const SizedBox(height: 24),
                      _PaymentMethod(
                        selectedValue: _selectedPaymentMethod,
                        onChanged: (val) => setState(() => _selectedPaymentMethod = val ?? 0),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _CartItemsList(
                  items: items,
                  onIncrement: _increment,
                  onDecrement: _decrement,
                  onRemove: _remove,
                ),
                const SizedBox(height: 32),
                _OrderSummary(subtotal: subtotal, tax: tax, delivery: items.isEmpty ? 0 : delivery, total: total),
                const SizedBox(height: 24),
                _PaymentMethod(
                  selectedValue: _selectedPaymentMethod,
                  onChanged: (val) => setState(() => _selectedPaymentMethod = val ?? 0),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  final List<CartItemModel> items;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onRemove;

  const _CartItemsList({
    required this.items,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Text(
          "El carrito está vacío",
          style: AppTextStyles.w500(fontSize: 18, color: AppColors.secondaryTextLight),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        // Container styled like the image
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5E4), // Light matching tone from mockup
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.bold(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: AppTextStyles.text(fontSize: 13, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.price,
                      style: AppTextStyles.bold(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Actions
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _CircleBtn(icon: Icons.remove, onTap: () => onDecrement(index)),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: AppTextStyles.w500(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      _CircleBtn(icon: Icons.add, onTap: () => onIncrement(index)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onRemove(index),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(
                            LandingStrings.btnDelete,
                            style: AppTextStyles.w500(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double delivery;
  final double total;

  const _OrderSummary({
    required this.subtotal,
    required this.tax,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5E4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8CBAF)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LandingStrings.orderSummary,
            style: AppTextStyles.text(fontSize: 22, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          _SummaryRow(title: LandingStrings.subtotal, value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(title: LandingStrings.tax, value: '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(title: LandingStrings.delivery, value: '\$${delivery.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.black12, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LandingStrings.total,
                style: AppTextStyles.bold(fontSize: 20, color: Colors.black87),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyles.bold(fontSize: 20, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreenLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: total == 0 ? null : () {},
              child: Text(
                LandingStrings.btnCheckout,
                style: AppTextStyles.w500(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.text(fontSize: 16, color: Colors.black87)),
        Text(value, style: AppTextStyles.text(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const _PaymentMethod({required this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5E4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8CBAF)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              LandingStrings.paymentMethodTitle,
              style: AppTextStyles.text(fontSize: 20, color: Colors.black87),
            ),
          ),
          _PaymentOption(
            value: 0,
            groupValue: selectedValue,
            label: '•••• 4242',
            iconWidget: _CardLogo('VISA', Colors.blue.shade900),
            onChanged: onChanged,
          ),
          _PaymentOption(
            value: 1,
            groupValue: selectedValue,
            label: 'PSE',
            iconWidget: _CardLogo('PSE', Colors.teal),
            onChanged: onChanged,
          ),
          _PaymentOption(
            value: 2,
            groupValue: selectedValue,
            label: 'Nequi',
            iconWidget: _CardLogo('nequi', Colors.purple),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final int value;
  final int groupValue;
  final String label;
  final Widget iconWidget;
  final ValueChanged<int?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.iconWidget,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              value == groupValue ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: value == groupValue ? AppColors.buttonGreenLight : Colors.black26,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.text(fontSize: 16, color: Colors.black87)),
            const Spacer(),
            iconWidget,
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CardLogo extends StatelessWidget {
  final String text;
  final Color color;
  const _CardLogo(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTextStyles.bold(fontSize: 12, color: color),
      ),
    );
  }
}
