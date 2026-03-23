import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/pos_order.dart';
import 'package:intl/intl.dart';

class PosOrderPanel extends StatelessWidget {
  final List<PosCartItem> orderItems;
  final String orderType;
  final Function(String)? onNameChanged;
  final VoidCallback? onPlaceOrder;
  final VoidCallback? onPayOrder;

  const PosOrderPanel({
    super.key,
    required this.orderItems,
    required this.orderType,
    this.onNameChanged,
    this.onPlaceOrder,
    this.onPayOrder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final format = NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: isDark ? colorScheme.outlineVariant : Colors.black12,
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          // Order Header
          _OrderHeader(
            orderType: orderType,
            onNameChanged: onNameChanged,
          ),

          const Divider(height: 1),

          // Order Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quantity indicator
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white12
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: AppTextStyles.bold(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.selectedSize != null ? '${item.product.name} (${item.selectedSize})' : item.product.name,
                              style: AppTextStyles.w500(
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (item.product.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.product.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.text(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Price
                      Text(
                        format.format(item.product.price * item.quantity),
                        style: AppTextStyles.bold(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            Icons.edit,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Summary and Actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  isDark ? colorScheme.surfaceContainerHighest : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? colorScheme.outlineVariant : Colors.black12,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Totals
                Builder(
                  builder: (context) {
                    final subtotal = orderItems.fold<double>(0, (sum, item) => sum + (item.product.price * item.quantity));
                    final tax = subtotal * 0.10;
                    final total = subtotal + tax;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal',
                                style: AppTextStyles.text(
                                    color: colorScheme.onSurfaceVariant)),
                            Text(format.format(subtotal),
                                style: AppTextStyles.w500(
                                    color: colorScheme.onSurface)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Impuestos (10%)',
                                style: AppTextStyles.text(
                                    color: colorScheme.onSurfaceVariant)),
                            Text(format.format(tax),
                                style:
                                    AppTextStyles.w500(color: colorScheme.onSurface)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: AppTextStyles.bold(
                                    fontSize: 18, color: colorScheme.onSurface)),
                            Text(format.format(total),
                                style: AppTextStyles.bold(
                                    fontSize: 22, color: colorScheme.primary)),
                          ],
                        ),
                      ],
                    );
                  }
                ),

                const SizedBox(height: 24),

                // Action Buttons mapped to ThemeData
                // _ActionButton(
                //   label: 'AGREGAR NOTAS DE COCINA',
                //   color: colorScheme.tertiaryContainer, // Naranja
                //   textColor: colorScheme.onTertiaryContainer,
                //   onPressed: () {},
                // ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'HACER PEDIDO',
                  color: colorScheme.primaryContainer, // Verde
                  textColor: colorScheme.onPrimaryContainer,
                  icon: Icons.send_outlined,
                  onPressed: onPlaceOrder ?? () {},
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'COBRAR',
                  color: const Color.fromRGBO(205, 33, 42, 1), // Dark Blue
                  textColor: colorScheme.onSecondaryContainer,
                  icon: Icons.payments_outlined,
                  onPressed: onPayOrder ?? () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.bold(fontSize: 13, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHeader extends StatefulWidget {
  final String orderType;
  final Function(String)? onNameChanged;
  
  const _OrderHeader({required this.orderType, this.onNameChanged});

  @override
  State<_OrderHeader> createState() => _OrderHeaderState();
}

class _OrderHeaderState extends State<_OrderHeader> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.orderType);
  }

  @override
  void didUpdateWidget(covariant _OrderHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderType != widget.orderType && !_isEditing) {
      // Si cambia el tipo de orden desde otra parte y no estamos editando, podemos querer actualizarlo.
      // Pero para permitir que el comensal se quede con un nombre custom, podríamos no sobreescribirlo 
      // si ya lo cambiaron manualmente. Para mayor simplicidad, si vuelve a cambiar actualizamos el campo:
      _controller.text = widget.orderType;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        widget.onNameChanged?.call(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Orden #451 - ',
                  style: AppTextStyles.bold(
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (_isEditing)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _controller,
                          style: AppTextStyles.bold(
                            fontSize: 18,
                            color: colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                          ),
                          onSubmitted: (_) => _toggleEdit(),
                          autofocus: true,
                        ),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: Text(
                      _controller.text.isEmpty ? 'Cliente' : _controller.text,
                      style: AppTextStyles.bold(
                        fontSize: 18,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (!_isEditing) const SizedBox(width: 8),
                InkWell(
                  onTap: _toggleEdit,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      _isEditing ? Icons.check : Icons.edit_outlined,
                      size: 20, 
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
