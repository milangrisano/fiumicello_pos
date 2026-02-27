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
  static const String invalidEmailError = 'No ingresaste un correo o una estructura de correo válida';
  static const String passwordHint = 'Contraseña';
  static const String passwordError = 'Ingresa tu contraseña';
  static const String loginError = 'Email o contraseña incorrectos.';

  static const String createAccountTitle = 'Únete a Fiumicello';
  static const String nameHint = 'Nombre y Apellido';
  static const String confirmPassHint = 'Confirmar Contraseña';
  static const String confirmPassError = 'Las contraseñas no coinciden';
  static const String btnRegister = 'Registrarse';
  static const String haveAccountText1 = '¿Ya tienes cuenta? ';
  static const String haveAccountText2 = 'Inicia sesión';
  
  // Cart
  static const String cartTitle = 'Your Shopping Cart';
  static const String orderSummary = 'Order Summary';
  static const String subtotal = 'Subtotal';
  static const String tax = 'Tax';
  static const String delivery = 'Delivery';
  static const String total = 'Total';
  static const String btnCheckout = 'Checkout';
  static const String paymentMethodTitle = 'Payment Method';
  static const String btnDelete = 'Delete';
  static const String btnBackToProducts = 'Volver a productos';
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
  LandingMenuItem(name: 'Tagliatelle al Tartufo Nero', description: 'Creamy tagliatelle with Parmesan and Parmesan', price: '\$28.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'assets/images/product/tagliatelle_tartufo.jpg'),
  LandingMenuItem(name: 'Carbonara Autentica', description: 'Rigatoni coated with a silky egg and pecorino sauce with guanciale', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'assets/images/product/carbonara.jpg'),
  LandingMenuItem(name: 'Orecchiette con Cime di Rapa', description: 'Ear-shaped pasta with broccoli rabe, garlic, and chili', price: '\$22.00', category: 'Primi', plateColor: Color(0xFF90EE90), imageUrl: 'assets/images/product/orecchiette.jpg'),
  LandingMenuItem(name: 'Gnocchi alla Sorrentina', description: 'Fluffy potato gnocchi in a vibrant tomato and basil sauce with melting mozzarella', price: '\$26.00', category: 'Primi', plateColor: Color(0xFFFF6347), imageUrl: 'assets/images/product/gnocchi.jpg'),
  LandingMenuItem(name: 'Pappardelle al Cinghiale', description: 'Rich wild boar ragù with wide ribbon pasta', price: '\$29.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'assets/images/product/pappardelle.jpg'),
  LandingMenuItem(name: 'Risotto ai Funghi Porcini', description: 'Creamy Arborio rice with wild porcini mushrooms', price: '\$25.00', category: 'Primi', plateColor: Color(0xFFE0E0E0), imageUrl: 'assets/images/product/risotto_funghi.jpg'),
  LandingMenuItem(name: 'Linguine allo Scoglio', description: 'Seafood pasta with mussels, clams, shrimp, and calamari', price: '\$32.00', category: 'Primi', plateColor: Color(0xFFFFB6C1), imageUrl: 'assets/images/product/linguine_scoglio.jpg'),
  LandingMenuItem(name: 'Agnolotti del Plin', description: 'Piedmontese stuffed pasta with roasted meat reduction', price: '\$24.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'assets/images/product/agnolotti.jpg'),
  LandingMenuItem(name: 'Bucatini all\'Amatriciana', description: 'Thick hollow pasta with guanciale, tomato, and pecorino', price: '\$21.00', category: 'Primi', plateColor: Color(0xFFFF6347), imageUrl: 'assets/images/product/bucatini.jpg'),
  LandingMenuItem(name: 'Ravioli Ricotta e Spinaci', description: 'Handmade ravioli in sage and brown butter sauce', price: '\$20.00', category: 'Primi', plateColor: Color(0xFF90EE90), imageUrl: 'assets/images/product/ravioli.jpg'),
  LandingMenuItem(name: 'Spaghetti Cacio e Pepe', description: 'Classic Roman pasta with pecorino romano and black pepper', price: '\$19.00', category: 'Primi', plateColor: Color(0xFFF5DEB3), imageUrl: 'assets/images/product/spaghetti_cacio.jpg'),
  LandingMenuItem(name: 'Lasagna Tradizionale', description: 'Baked layers of fresh pasta, rich ragù, and béchamel', price: '\$25.00', category: 'Primi', plateColor: Color(0xFFFFD700), imageUrl: 'assets/images/product/lasagna.jpg'),
  // Secondi
  LandingMenuItem(name: 'Osso Buco alla Milanese', description: 'Braised veal shank with gremolata over saffron risotto', price: '\$42.00', category: 'Secondi', plateColor: Color(0xFFFFD700), imageUrl: 'assets/images/product/osso_buco.jpg'),
  LandingMenuItem(name: 'Filetto di Manzo al Barolo', description: 'Tender beef fillet with a red wine reduction and roasted vegetables', price: '\$48.00', category: 'Secondi', plateColor: Color(0xFF8B4513), imageUrl: 'assets/images/product/filetto_manzo.jpg'),
  LandingMenuItem(name: 'Branzino al Forno', description: 'Whole roasted sea bass with lemon, herbs and cherry tomatoes', price: '\$38.00', category: 'Secondi', plateColor: Color(0xFFE0E0E0), imageUrl: 'assets/images/product/branzino.jpg'),
  LandingMenuItem(name: 'Cotoletta alla Bolognese', description: 'Breaded veal cutlet topped with prosciutto and Parmesan crostini', price: '\$36.00', category: 'Secondi', plateColor: Color(0xFFF5DEB3), imageUrl: 'assets/images/product/cotoletta.jpg'),
  // Antipasti
  LandingMenuItem(name: 'Bruschetta al Pomodoro', description: 'Toasted bread with fresh tomatoes, basil and extra-virgin olive oil', price: '\$12.00', category: 'Antipasti', plateColor: Color(0xFFFF6347), imageUrl: 'assets/images/product/bruschetta.jpg'),
  LandingMenuItem(name: 'Carpaccio di Manzo', description: 'Paper-thin beef slices with arugula, capers and Parmesan shavings', price: '\$18.00', category: 'Antipasti', plateColor: Color(0xFFFFB6C1), imageUrl: 'assets/images/product/carpaccio.jpg'),
  // Contorni
  LandingMenuItem(name: 'Patate al Forno', description: 'Oven-roasted potatoes with rosemary and garlic', price: '\$9.00', category: 'Contorni', plateColor: Color(0xFFFFD700), imageUrl: 'assets/images/product/patate.jpg'),
  LandingMenuItem(name: 'Verdure Grigliate', description: 'Grilled seasonal vegetables with extra-virgin olive oil', price: '\$11.00', category: 'Contorni', plateColor: Color(0xFF90EE90), imageUrl: 'assets/images/product/verdure.jpg'),
  // Dolci
  LandingMenuItem(name: 'Tiramisù Classico', description: 'Classic espresso-soaked ladyfingers with mascarpone cream', price: '\$10.00', category: 'Dolci', plateColor: Color(0xFF8B4513), imageUrl: 'assets/images/product/tiramisu.jpg'),
  LandingMenuItem(name: 'Panna Cotta al Frutti di Bosco', description: 'Silky vanilla panna cotta with mixed berry coulis', price: '\$9.00', category: 'Dolci', plateColor: Color(0xFFFF69B4), imageUrl: 'assets/images/product/panna_cotta.jpg'),
];

class CartItemModel {
  final LandingMenuItem product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
}

// Dummy data using some of the exact products in the mock image
final List<CartItemModel> mockCartItems = [
  CartItemModel(
    product: landingMenuItems.firstWhere((p) => p.name.contains('Carbonara')), 
    quantity: 1,
  ),
  CartItemModel(
    product: landingMenuItems.firstWhere((p) => p.name.contains('Tiramisù')), 
    quantity: 1,
  ),
  CartItemModel(
    product: landingMenuItems.firstWhere((p) => p.name.contains('Osso Buco')), // Reemplaza Risotto alla Milanese que no está 
    quantity: 1,
  ),
];
