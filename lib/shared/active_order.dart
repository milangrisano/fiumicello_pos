import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_takeaway.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

class ActiveOrders extends StatelessWidget {
  final Color panelColor;
  final Color goldColor;
  final List<InfoTakeaway> activeOrders;
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
                          ? goldColor.withValues(alpha: 0.15) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: goldColor.withValues(alpha: 0.5)) 
                          : Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  order.id,
                                  style: AppTextStyles.bold().copyWith(
                                    color: isSelected ? goldColor : Colors.white54,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  order.time,
                                  style: AppTextStyles.text().copyWith(
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.name,
                              style: AppTextStyles.w500(fontSize: 16).copyWith(
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
                  style: AppTextStyles.bold(fontSize: 18).copyWith(
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