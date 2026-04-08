import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/table.dart';
import 'package:responsive_app/configure/api_config.dart';

class TableService {
  Future<List<TableModel>> getTables({String? restaurantId}) async {
    final headers = await ApiConfig.getHeaders(requireAuth: true);
    final uri = restaurantId != null 
        ? Uri.parse('${ApiConfig.baseUrl}/tables?restaurantId=$restaurantId')
        : Uri.parse('${ApiConfig.baseUrl}/tables');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TableModel.fromJson(json)).toList();
    } else {
      throw Exception('Error loading tables: ${response.statusCode}');
    }
  }

  Future<TableModel> createTable(String name, String restaurantId, double x, double y) async {
    final headers = await ApiConfig.getHeaders(requireAuth: true);
    final body = jsonEncode({
      'name': name,
      'restaurantId': restaurantId,
      'isActive': true,
      'x': x,
      'y': y,
    });

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/tables'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      return TableModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating table: ${response.body}');
    }
  }

  Future<TableModel> updateTable(int id, double x, double y) async {
    final headers = await ApiConfig.getHeaders(requireAuth: true);
    final body = jsonEncode({
      'x': x,
      'y': y,
    });

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/tables/$id'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return TableModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error updating table: ${response.body}');
    }
  }

  Future<void> deleteTable(int id) async {
    final headers = await ApiConfig.getHeaders(requireAuth: true);
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/tables/$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error deleting table: ${response.body}');
    }
  }
}
