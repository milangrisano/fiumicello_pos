import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String serverUrl = 'http://localhost:3000';
  static const String baseUrl = '$serverUrl/api';

  static Future<Map<String, String>> getHeaders({bool requireAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    
    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
}
