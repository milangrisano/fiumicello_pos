import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/product.dart';

class ProductService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Return empty list or throw depending on error handling strategy
      throw Exception('Error fetching products: $e');
    }
  }

  // Extraer lista única de categorías desde los productos
  List<String> extractCategories(List<Product> products) {
    final categories = products.map((p) => p.category).toSet().toList();
    // Default to a fallback list if empty, useful for initial debugging
    if (categories.isEmpty) {
      return ['Pastas', 'Pizzas', 'Bebidas'];
    }
    return categories;
  }
}
