import 'package:flutter/material.dart';

class InfoOrderItem {
  final String quantity;
  final String name;
  final String price;
  final IconData icon;

  InfoOrderItem({
    required this.quantity,
    required this.name,
    required this.price,
    required this.icon,
  });
}

List<InfoOrderItem> orderItemsContent = [
  InfoOrderItem(
    quantity: '1',
    name: 'Pizza Margherita',
    price: '\$16.00',
    icon: Icons.local_pizza,
  ),
  InfoOrderItem(
    quantity: '2',
    name: 'Spaghetti Carbonara',
    price: '\$36.00',
    icon: Icons.dinner_dining,
  ),
  InfoOrderItem(
    quantity: '1',
    name: 'Tiramisu',
    price: '\$10.00',
    icon: Icons.cake,
  ),
];
