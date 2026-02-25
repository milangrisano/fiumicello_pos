import 'package:flutter/material.dart';

class ProductCategory {
  final String name;
  final IconData icon;

  const ProductCategory({required this.name, required this.icon});
}

class ProductItem {
  final String name;
  final String category;
  final String price;
  final IconData icon;

  const ProductItem({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
  });
}

const List<ProductCategory> productCategories = [
  ProductCategory(name: 'Todos',      icon: Icons.grid_view_rounded),
  ProductCategory(name: 'Pizzas',     icon: Icons.local_pizza),
  ProductCategory(name: 'Pastas',     icon: Icons.dinner_dining),
  ProductCategory(name: 'Lasagnas',   icon: Icons.restaurant),
  ProductCategory(name: 'Paninis',    icon: Icons.lunch_dining),
  ProductCategory(name: 'Bebidas',    icon: Icons.local_bar),
  ProductCategory(name: 'Postres',    icon: Icons.cake),
];

const List<ProductItem> productCatalog = [
  // Pizzas
  ProductItem(name: 'Pizza Margherita',    category: 'Pizzas',  price: '\$16.00', icon: Icons.local_pizza),
  ProductItem(name: 'Pizza Pepperoni',     category: 'Pizzas',  price: '\$18.00', icon: Icons.local_pizza),
  ProductItem(name: 'Pizza 4 Stagioni',    category: 'Pizzas',  price: '\$20.00', icon: Icons.local_pizza),
  ProductItem(name: 'Pizza Funghi',        category: 'Pizzas',  price: '\$17.00', icon: Icons.local_pizza),
  // Pastas
  ProductItem(name: 'Spaghetti Carbonara', category: 'Pastas',  price: '\$18.00', icon: Icons.dinner_dining),
  ProductItem(name: 'Penne Arrabiata',     category: 'Pastas',  price: '\$15.00', icon: Icons.dinner_dining),
  ProductItem(name: 'Tagliatelle Bolognese', category: 'Pastas', price: '\$19.00', icon: Icons.dinner_dining),
  // Lasagnas
  ProductItem(name: 'Lasagna Classica',    category: 'Lasagnas', price: '\$21.00', icon: Icons.restaurant),
  ProductItem(name: 'Lasagna Verdure',     category: 'Lasagnas', price: '\$19.00', icon: Icons.restaurant),
  // Paninis
  ProductItem(name: 'Panini Caprese',      category: 'Paninis',  price: '\$11.00', icon: Icons.lunch_dining),
  ProductItem(name: 'Panini Prosciutto',   category: 'Paninis',  price: '\$12.00', icon: Icons.lunch_dining),
  // Bebidas
  ProductItem(name: 'Vino Rosso',          category: 'Bebidas',  price: '\$9.00',  icon: Icons.local_bar),
  ProductItem(name: 'Acqua Frizzante',     category: 'Bebidas',  price: '\$4.00',  icon: Icons.local_bar),
  ProductItem(name: 'Caffè Espresso',      category: 'Bebidas',  price: '\$3.50',  icon: Icons.local_cafe),
  // Postres
  ProductItem(name: 'Tiramisu',            category: 'Postres',  price: '\$10.00', icon: Icons.cake),
  ProductItem(name: 'Panna Cotta',         category: 'Postres',  price: '\$8.00',  icon: Icons.cake),
];
