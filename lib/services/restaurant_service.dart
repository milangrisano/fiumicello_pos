import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/restaurant.dart';

class RestaurantService {
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/restaurants'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching restaurants: $e');
    }
  }

  Future<Restaurant> createRestaurant(String name, String city, String? address) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/restaurants'),
        headers: headers,
        body: json.encode({
          'name': name,
          'city': city,
          if (address != null) 'address': address,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Restaurant.fromJson(data);
      } else {
        throw Exception('Failed to create restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating restaurant: $e');
    }
  }

  Future<Restaurant> updateRestaurant(String id, String name, String city, String? address) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/restaurants/$id'),
        headers: headers,
        body: json.encode({
          'name': name,
          'city': city,
          if (address != null) 'address': address,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Restaurant.fromJson(data);
      } else {
        throw Exception('Failed to update restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating restaurant: $e');
    }
  }

  Future<void> updateRestaurantStatus(String id, bool isActive) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      String endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/restaurants/$id/$endpoint'),
        headers: headers,
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        final fallbackResponse = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/restaurants/$id'),
          headers: headers,
          body: json.encode({
            'isActive': isActive,
          }),
        );
        
        if (fallbackResponse.statusCode != 200) {
           throw Exception('Failed to update restaurant status (Fallback): ${fallbackResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating restaurant status: $e');
    }
  }
}
