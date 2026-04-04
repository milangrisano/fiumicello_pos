import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/product.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> createProduct(String name, String type, String categoryId, double price, String description, String restaurantId) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/products'),
        headers: headers,
        body: json.encode({
          'name': name,
          'type': type,
          'categoryId': categoryId,
          'restaurantId': restaurantId,
          'description': description,
          'price': price,
          'availability': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<Product> updateProduct(String id, String name, String type, String categoryId, double price, String description, String restaurantId) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/products/$id'),
        headers: headers,
        body: json.encode({
          'name': name,
          'type': type,
          'categoryId': categoryId,
          'restaurantId': restaurantId,
          'description': description,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> updateProductStatus(String id, bool isActive) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      String endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/products/$id/$endpoint'),
        headers: headers,
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        final fallbackResponse = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/products/$id'),
          headers: headers,
          body: json.encode({
            'isActive': isActive,
          }),
        );
        
        if (fallbackResponse.statusCode != 200) {
           throw Exception('Failed to update product status (Fallback): ${fallbackResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating product status: $e');
    }
  }

  List<String> extractCategories(List<Product> products) {
    final categories = products.map((p) => p.category).where((c) => c.isNotEmpty).toSet().toList();
    if (categories.isEmpty) {
      return ['Pastas', 'Pizzas', 'Bebidas'];
    }
    return categories;
  }
}
