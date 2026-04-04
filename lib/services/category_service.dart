import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/category.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<Category> createCategory(String name, String? description) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/categories'),
        headers: headers,
        body: json.encode({
          'name': name,
          if (description != null && description.isNotEmpty) 'description': description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Category.fromJson(data);
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  Future<Category> updateCategory(String id, String name, String? description) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/categories/$id'),
        headers: headers,
        body: json.encode({
          'name': name,
          if (description != null && description.isNotEmpty) 'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Category.fromJson(data);
      } else {
        throw Exception('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<void> updateCategoryStatus(String id, bool isActive) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      String endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/categories/$id/$endpoint'),
        headers: headers,
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        // Fallback for full patch if specific endpoint isn't mapped
        final fallbackResponse = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/categories/$id'),
          headers: headers,
          body: json.encode({
            'isActive': isActive,
          }),
        );
        
        if (fallbackResponse.statusCode != 200) {
           throw Exception('Failed to update category status (Fallback): ${fallbackResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating category status: $e');
    }
  }
}
