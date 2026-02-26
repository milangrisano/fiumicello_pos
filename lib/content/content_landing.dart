import 'package:flutter/material.dart';

class LandingStrings {
  static const String fiumicelloLogo = 'Fiumicello';
  static const String estYear = 'Est. 2024';
  static const String welcome = 'Bienvenidos';
  static const String btnLogin = 'Login';
  static const String btnCreateAccount = 'Create an Account';
  static const String btnAddToCart = 'Añadir a comprar';
  
  static const String emailHint = 'Email';
  static const String emailError = 'Ingresa tu email';
  static const String passwordHint = 'Password';
  static const String passwordError = 'Ingresa tu contraseña';
  static const String loginError = 'Email o contraseña incorrectos.';
}

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
  final String imageUrl;

  const LandingMenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.plateColor,
    required this.imageUrl,
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
  LandingMenuItem(name: 'Tagliatelle al Tartufo Nero', description: 'Creamy tagliatelle with Parmesan and Parmesan', price: '\$28.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=500&q=80'),
  LandingMenuItem(name: 'Carbonara Autentica', description: 'Rigatoni coated with a silky egg and pecorino sauce with guanciale', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500&q=80'),
  LandingMenuItem(name: 'Orecchiette con Cime di Rapa', description: 'Ear-shaped pasta with broccoli rabe, garlic, and chili', price: '\$22.00', category: 'Primi', plateColor: Color(0xFF90EE90), imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=500&q=80'),
  LandingMenuItem(name: 'Gnocchi alla Sorrentina', description: 'Fluffy potato gnocchi in a vibrant tomato and basil sauce with melting mozzarella', price: '\$26.00', category: 'Primi', plateColor: Color(0xFFFF6347), imageUrl: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=500&q=80'),
  LandingMenuItem(name: 'Pappardelle al Cinghiale', description: 'Rich wild boar ragù with wide ribbon pasta', price: '\$29.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=500&q=80'),
  LandingMenuItem(name: 'Risotto ai Funghi Porcini', description: 'Creamy Arborio rice with wild porcini mushrooms', price: '\$25.00', category: 'Primi', plateColor: Color(0xFFE0E0E0), imageUrl: 'https://images.unsplash.com/photo-1633504581786-316c8002b1b9?w=500&q=80'),
  LandingMenuItem(name: 'Linguine allo Scoglio', description: 'Seafood pasta with mussels, clams, shrimp, and calamari', price: '\$32.00', category: 'Primi', plateColor: Color(0xFFFFB6C1), imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&q=80'),
  LandingMenuItem(name: 'Agnolotti del Plin', description: 'Piedmontese stuffed pasta with roasted meat reduction', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=500&q=80'),
  LandingMenuItem(name: 'Bucatini all\'Amatriciana', description: 'Thick hollow pasta with guanciale, tomato, and pecorino', price: '\$21.00', category: 'Primi', plateColor: Color(0xFFFF6347), imageUrl: 'https://images.unsplash.com/photo-1626844131082-256783844137?w=500&q=80'),
  LandingMenuItem(name: 'Ravioli Ricotta e Spinaci', description: 'Handmade ravioli in sage and brown butter sauce', price: '\$20.00', category: 'Primi', plateColor: Color(0xFF90EE90), imageUrl: 'https://images.unsplash.com/photo-1587740908075-9e245070dfaa?w=500&q=80'),
  LandingMenuItem(name: 'Spaghetti Cacio e Pepe', description: 'Classic Roman pasta with pecorino romano and black pepper', price: '\$19.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'https://images.unsplash.com/photo-1595295333158-4742f28fbd85?w=500&q=80'),
  LandingMenuItem(name: 'Lasagna Tradizionale', description: 'Baked layers of fresh pasta, rich ragù, and béchamel', price: '\$25.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'https://images.unsplash.com/photo-1619895092538-128341789043?w=500&q=80'),
  // Secondi
  LandingMenuItem(name: 'Osso Buco alla Milanese', description: 'Braised veal shank with gremolata over saffron risotto', price: '\$42.00', category: 'Secondi', plateColor: Color(0xFFFFD700), imageUrl: 'https://images.unsplash.com/photo-1621845199672-002166946ce7?w=500&q=80'),
  LandingMenuItem(name: 'Filetto di Manzo al Barolo', description: 'Tender beef fillet with a red wine reduction and roasted vegetables', price: '\$48.00', category: 'Secondi', plateColor: Color(0xFF8B4513), imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80'),
  LandingMenuItem(name: 'Branzino al Forno', description: 'Whole roasted sea bass with lemon, herbs and cherry tomatoes', price: '\$38.00', category: 'Secondi', plateColor: Color(0xFFE0E0E0), imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500&q=80'),
  LandingMenuItem(name: 'Cotoletta alla Bolognese', description: 'Breaded veal cutlet topped with prosciutto and Parmesan crostini', price: '\$36.00', category: 'Secondi', plateColor: Color(0xFFF5DEB3), imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80'),
  // Antipasti
  LandingMenuItem(name: 'Bruschetta al Pomodoro', description: 'Toasted bread with fresh tomatoes, basil and extra-virgin olive oil', price: '\$12.00', category: 'Antipasti', plateColor: Color(0xFFFF6347), imageUrl: 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=500&q=80'),
  LandingMenuItem(name: 'Carpaccio di Manzo', description: 'Paper-thin beef slices with arugula, capers and Parmesan shavings', price: '\$18.00', category: 'Antipasti', plateColor: Color(0xFFFFB6C1), imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80'),
  // Contorni
  LandingMenuItem(name: 'Patate al Forno', description: 'Oven-roasted potatoes with rosemary and garlic', price: '\$9.00', category: 'Contorni', plateColor: Color(0xFFFFD700), imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500&q=80'),
  LandingMenuItem(name: 'Verdure Grigliate', description: 'Grilled seasonal vegetables with extra-virgin olive oil', price: '\$11.00', category: 'Contorni', plateColor: Color(0xFF90EE90), imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&q=80'),
  // Dolci
  LandingMenuItem(name: 'Tiramisù Classico', description: 'Classic espresso-soaked ladyfingers with mascarpone cream', price: '\$10.00', category: 'Dolci', plateColor: Color(0xFF8B4513), imageUrl: 'https://images.unsplash.com/photo-1571873523292-132d751512bc?w=500&q=80'),
  LandingMenuItem(name: 'Panna Cotta al Frutti di Bosco', description: 'Silky vanilla panna cotta with mixed berry coulis', price: '\$9.00', category: 'Dolci', plateColor: Color(0xFFFF69B4), imageUrl: 'https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?w=500&q=80'),
];
