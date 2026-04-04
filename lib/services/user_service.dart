import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/page/utilities_page/users_page.dart';

class UserService {
  Future<List<UserModel>> getUsers() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          return UserModel(
            id: json['_id'] ?? json['id'] ?? '',
            name: json['name'] ?? '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
            email: json['email'] ?? '',
            phone: json['phone'] ?? '',
            role: _extractRole(json['role']),
            createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
            isActive: json['isActive'] ?? true,
          );
        }).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<void> updateUserRole(String userId, String roleId, {String? restaurantId}) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      final payload = <String, dynamic>{'roleId': int.tryParse(roleId) ?? roleId};
      if (restaurantId != null && restaurantId.isNotEmpty) {
        payload['restaurantId'] = restaurantId;
      }
      
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user role: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }

  String _extractRole(dynamic roleData) {
    if (roleData == null) return 'Guest';
    if (roleData is Map && roleData['name'] != null) {
      return roleData['name'].toString();
    }
    return roleData.toString();
  }
}
