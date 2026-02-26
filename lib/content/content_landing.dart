import 'package:flutter/material.dart';

class LandingCategory {
  final String name;
  const LandingCategory(this.name);
}

class LandingMenuItem {
  final String name;
  final String description;
  final String price;
  final String category;
  final Color plateColor;

  const LandingMenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.plateColor,
  });
}

const List<LandingCategory> landingCategories = [
  LandingCategory('Antipasti'),
  LandingCategory('Primi'),
  LandingCategory('Secondi'),
  LandingCategory('Contorni'),
  LandingCategory('Dolci'),
];

const List<LandingMenuItem> landingMenuItems = [
  // Primi
  LandingMenuItem(name: 'Tagliatelle al Tartufo Nero', description: 'Creamy tagliatelle with Parmesan and Parmesan', price: '\$28.00', category: 'Primi', plateColor: Color(0xFFF5DEB3)),
  LandingMenuItem(name: 'Carbonara Autentica', description: 'Rigatoni coated with a silky egg and pecorino sauce with guanciale', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700)),
  LandingMenuItem(name: 'Orecchiette con Cime di Rapa', description: 'Ear-shaped pasta with broccoli rabe, garlic, and chili', price: '\$22.00', category: 'Primi', plateColor: Color(0xFF90EE90)),
  LandingMenuItem(name: 'Gnocchi alla Sorrentina', description: 'Fluffy potato gnocchi in a vibrant tomato and basil sauce with melting mozzarella', price: '\$26.00', category: 'Primi', plateColor: Color(0xFFFF6347)),
  // Secondi
  LandingMenuItem(name: 'Osso Buco alla Milanese', description: 'Braised veal shank with gremolata over saffron risotto', price: '\$42.00', category: 'Secondi', plateColor: Color(0xFFFFD700)),
  LandingMenuItem(name: 'Filetto di Manzo al Barolo', description: 'Tender beef fillet with a red wine reduction and roasted vegetables', price: '\$48.00', category: 'Secondi', plateColor: Color(0xFF8B4513)),
  LandingMenuItem(name: 'Branzino al Forno', description: 'Whole roasted sea bass with lemon, herbs and cherry tomatoes', price: '\$38.00', category: 'Secondi', plateColor: Color(0xFFE0E0E0)),
  LandingMenuItem(name: 'Cotoletta alla Bolognese', description: 'Breaded veal cutlet topped with prosciutto and Parmesan crostini', price: '\$36.00', category: 'Secondi', plateColor: Color(0xFFF5DEB3)),
  // Antipasti
  LandingMenuItem(name: 'Bruschetta al Pomodoro', description: 'Toasted bread with fresh tomatoes, basil and extra-virgin olive oil', price: '\$12.00', category: 'Antipasti', plateColor: Color(0xFFFF6347)),
  LandingMenuItem(name: 'Carpaccio di Manzo', description: 'Paper-thin beef slices with arugula, capers and Parmesan shavings', price: '\$18.00', category: 'Antipasti', plateColor: Color(0xFFFFB6C1)),
  // Contorni
  LandingMenuItem(name: 'Patate al Forno', description: 'Oven-roasted potatoes with rosemary and garlic', price: '\$9.00', category: 'Contorni', plateColor: Color(0xFFFFD700)),
  LandingMenuItem(name: 'Verdure Grigliate', description: 'Grilled seasonal vegetables with extra-virgin olive oil', price: '\$11.00', category: 'Contorni', plateColor: Color(0xFF90EE90)),
  // Dolci
  LandingMenuItem(name: 'Tiramisù Classico', description: 'Classic espresso-soaked ladyfingers with mascarpone cream', price: '\$10.00', category: 'Dolci', plateColor: Color(0xFF8B4513)),
  LandingMenuItem(name: 'Panna Cotta al Frutti di Bosco', description: 'Silky vanilla panna cotta with mixed berry coulis', price: '\$9.00', category: 'Dolci', plateColor: Color(0xFFFF69B4)),
];
