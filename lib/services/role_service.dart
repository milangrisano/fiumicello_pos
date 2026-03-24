import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/role.dart';

class RoleService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  Future<List<RoleDefinitionModel>> getRoles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/roles'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RoleDefinitionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load roles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching roles: $e');
    }
  }

  Future<RoleDefinitionModel> createRole(String name, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/roles'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'isActive': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return RoleDefinitionModel.fromJson(data);
      } else {
        throw Exception('Failed to create role: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating role: $e');
    }
  }

  Future<void> updateRoleStatus(String id, bool isActive) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/roles/$id/deactivate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isActive': isActive}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update role status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating role status: $e');
    }
  }
}
