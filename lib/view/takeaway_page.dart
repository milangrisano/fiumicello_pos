import 'package:flutter/material.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

class TakeawayPage extends StatefulWidget {
  const TakeawayPage({super.key});

  @override
  State<TakeawayPage> createState() => _TakeawayPageState();
}

class _TakeawayPageState extends State<TakeawayPage> {

  // Data for mockup
  final List<Map<String, dynamic>> _activeOrders = [
    {'id': '710092021', 'name': 'Marrika Cocino', 'status': 'Selected'},
    {'id': '710092074', 'name': 'Gnocchi alla Torrentina', 'status': 'Cooking'},
    {'id': '710092025', 'name': 'Brasab Bazolo', 'status': 'Ready'},
  ];

  int _selectedOrderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // LEFT PANEL - Active Orders
            Expanded(
              flex: 2,
              child: ActiveOrders(
                panelColor: AppColors.panel,
                goldColor: AppColors.gold,
                activeOrders: _activeOrders,
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
                            style: AppTextStyles.header(fontSize: 18).copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '7:31 PM',
                            style: AppTextStyles.sectionTitle(fontSize: 18).copyWith(
                              color: AppColors.gold,
                            ),
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
                            style: AppTextStyles.label().copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Juan Pérez',
                            style: AppTextStyles.goldValue(fontSize: 18).copyWith(
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    // Items List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildOrderItem('1', 'Pizza Margherita', '\$16.00', Icons.local_pizza),
                          _buildOrderItem('2', 'Spaghetti Carbonara', '\$36.00', Icons.dinner_dining),
                          _buildOrderItem('1', 'Tiramisu', '\$10.00', Icons.cake),
                        ],
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
                                style: AppTextStyles.pageTitle(fontSize: 18).copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '\$65.88',
                                style: AppTextStyles.totalValue(fontSize: 24).copyWith(
                                  color: AppColors.gold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                
                    // Pay Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
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
                            style: AppTextStyles.buttonText(fontSize: 18).copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ),
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
            style: AppTextStyles.goldValue(fontSize: 16).copyWith(
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.body(fontSize: 16).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Text(
            price,
            style: AppTextStyles.price(fontSize: 16).copyWith(
              color: Colors.white,
            ),
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
              ? AppTextStyles.labelMuted(fontSize: 16).copyWith(color: Colors.white38) 
              : AppTextStyles.labelLarge(fontSize: 16).copyWith(color: Colors.white54),
        ),
        Text(
          value,
          style: AppTextStyles.bodyBold(fontSize: 16).copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class ActiveOrders extends StatelessWidget {
  final Color panelColor;
  final Color goldColor;
  final List<Map<String, dynamic>> activeOrders;
  final int selectedIndex;
  final Function(int) onOrderSelected;

  const ActiveOrders({
    super.key,
    required this.panelColor,
    required this.goldColor,
    required this.activeOrders,
    required this.selectedIndex,
    required this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ordenes para llevar',
                style: AppTextStyles.pageTitle(fontSize: 18).copyWith(
                  color: Colors.white70,
                ),
              ),
            ),
          ),

          // Order List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onOrderSelected(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? goldColor.withOpacity(0.15) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: goldColor.withOpacity(0.5)) 
                          : Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['id'],
                              style: AppTextStyles.orderId().copyWith(
                                color: isSelected ? goldColor : Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order['name'],
                              style: AppTextStyles.bodyBold(fontSize: 16).copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          Icon(Icons.circle, color: goldColor, size: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // New Order Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'NUEVA ORDEN',
                  style: AppTextStyles.buttonText(fontSize: 18).copyWith(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color selectedColor;

  const TabItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: isSelected 
            ? AppTextStyles.filterLabel().copyWith(color: Colors.black87) 
            : AppTextStyles.filterLabelUnselected().copyWith(color: Colors.white70),
      ),
    );
  }
}
