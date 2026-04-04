import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/terminal.dart';

class TerminalService {
  Future<List<Terminal>> getTerminals() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/terminals'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Terminal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load terminals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching terminals: $e');
    }
  }

  Future<Terminal> createTerminal(String name) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/terminals'),
        headers: headers,
        body: json.encode({
          'name': name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Terminal.fromJson(data);
      } else {
        throw Exception('Failed to create terminal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating terminal: $e');
    }
  }

  Future<Terminal> updateTerminal(int id, String name) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/terminals/$id'),
        headers: headers,
        body: json.encode({
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Terminal.fromJson(data);
      } else {
        throw Exception('Failed to update terminal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating terminal: $e');
    }
  }

  Future<void> updateTerminalStatus(int id, bool isActive) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      String endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/terminals/$id/$endpoint'),
        headers: headers,
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        final fallbackResponse = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/terminals/$id'),
          headers: headers,
          body: json.encode({
            'isActive': isActive,
          }),
        );
        
        if (fallbackResponse.statusCode != 200) {
           throw Exception('Failed to update terminal status (Fallback): ${fallbackResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating terminal status: $e');
    }
  }
}
