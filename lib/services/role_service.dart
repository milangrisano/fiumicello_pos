import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/role.dart';
import 'package:responsive_app/configure/api_config.dart';

class RoleService {
  Future<List<RoleDefinitionModel>> getRoles() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/roles'),
        headers: headers,
      );

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
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/roles'),
        headers: headers,
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
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/roles/$id/$endpoint'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update role status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating role status: $e');
    }
  }

  Future<void> updateRolePermissions(String id, List<String> permissions, {String? defaultRoute}) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final Map<String, dynamic> bodyData = {
           'permissions': permissions,
         };
        if (defaultRoute != null) {
          bodyData['defaultRoute'] = defaultRoute;
        }
      
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/roles/$id'),
        headers: headers,
        body: json.encode(bodyData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update role permissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating role permissions: $e');
    }
  }
}
