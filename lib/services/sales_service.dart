import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/sale.dart';

class SalesService {
  Future<List<SaleModel>> getSales() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/sales'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => SaleModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener ventas: Código ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Excepción al conectar con el servidor: $e');
    }
  }
}
