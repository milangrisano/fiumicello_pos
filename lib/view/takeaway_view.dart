import 'package:flutter/material.dart';
import 'package:responsive_app/shared/active_order.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';
import 'package:responsive_app/widgets/add_product_modal.dart';
import '../content/content_takeaway.dart';
import '../content/content_order_item.dart';

class TakeawayView extends StatefulWidget {
  const TakeawayView({super.key});

  @override
  State<TakeawayView> createState() => _TakeawayViewState();
}

class _TakeawayViewState extends State<TakeawayView> {

  int _selectedOrderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // LEFT PANEL - Active Orders
            Expanded(
              flex: 1,
              child: ActiveOrders(
                panelColor: AppColors.panel,
                goldColor: AppColors.gold,
                activeOrders: takeawayContent,
                selectedIndex: _selectedOrderIndex,
                onOrderSelected: (index) {
                  setState(() {
                    _selectedOrderIndex = index;
                  });
                },
              ),
            ),
            
            const SizedBox(width: 10),
            
            // RIGHT PANEL - Order Details
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Details',
                            style: AppTextStyles.w500(fontSize: 18),
                          ),
                          Text(
                            '7:31 PM',
                            style: AppTextStyles.w500(fontSize: 18, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                
                    // Customer Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          Text(
                            'Customer Name: ',
                            style: AppTextStyles.text(color: Colors.white54),
                          ),
                          const Spacer(),
                          Text(
                            'Juan Pérez',
                            style: AppTextStyles.bold(fontSize: 18, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                
                    // Items List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orderItemsContent.length,
                        itemBuilder: (context, index) {
                          final item = orderItemsContent[index];
                          return _buildOrderItem(item.quantity, item.name, item.price, item.icon);
                        },
                      ),
                    ),
                
                    // Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.black12,
                      child: Column(
                        children: [
                          _buildSummaryRow('Subtotal:', '\$81.00'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Tax (9%):', '\$4.88', isMuted: true),
                          const Divider(color: Colors.white10, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: AppTextStyles.pageTitle(fontSize: 18, color: Colors.white70),
                              ),
                              Text(
                                '\$65.88',
                                style: AppTextStyles.bold(fontSize: 24, color: AppColors.gold),
                              ),
                            ],  
                          ),
                        ],
                      ),
                    ),
                
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.75,
                                      child: AddProductModal(
                                        customerName: 'Juan Pérez',
                                        orderId: '710092021',
                                      ),
                                    ),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.gold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'AGREGAR\nPRODUCTO',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bold(fontSize: 14, color: AppColors.gold, height: 1.2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'PAGAR',
                                  style: AppTextStyles.bold(fontSize: 18, color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String qty, String name, String price, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
              image: null, // Placeholder for image
            ),
            child: Icon(icon, color: Colors.white54),
          ),
          const SizedBox(width: 12),
          Text(
            qty,
            style: AppTextStyles.bold(fontSize: 16).copyWith(
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.text(fontSize: 16),
            ),
          ),
          Text(
            price,
            style: AppTextStyles.text(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isMuted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isMuted 
              ? AppTextStyles.text(fontSize: 16, color: Colors.white38) 
              : AppTextStyles.text(fontSize: 16, color: Colors.white54),
        ),
        Text(
          value,
          style: AppTextStyles.w500(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}