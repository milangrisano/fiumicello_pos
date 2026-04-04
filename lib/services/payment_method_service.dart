import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/models/payment_method.dart';

class PaymentMethodService {
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/payment-methods'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payment methods: $e');
    }
  }

  Future<PaymentMethod> createPaymentMethod(String name) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/payment-methods'),
        headers: headers,
        body: json.encode({
          'name': name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return PaymentMethod.fromJson(data);
      } else {
        throw Exception('Failed to create payment method: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating payment method: $e');
    }
  }

  Future<PaymentMethod> updatePaymentMethod(int id, String name) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/payment-methods/$id'),
        headers: headers,
        body: json.encode({
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PaymentMethod.fromJson(data);
      } else {
        throw Exception('Failed to update payment method: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating payment method: $e');
    }
  }

  Future<void> updatePaymentMethodStatus(int id, bool isActive) async {
    try {
      final headers = await ApiConfig.getHeaders(requireAuth: true);
      
      // Intentamos usar el endpoint de desactivación / activación como dice la regla
      String endpoint = isActive ? 'activate' : 'deactivate';
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/payment-methods/$id/$endpoint'),
        headers: headers,
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        // Fallback en caso de que el backend no tenga expuesto el endpoint específico
        // enviando directamente en el PATCH regular
        final fallbackResponse = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/payment-methods/$id'),
          headers: headers,
          body: json.encode({
            'isActive': isActive,
          }),
        );
        
        if (fallbackResponse.statusCode != 200) {
           throw Exception('Failed to update status (Fallback): ${fallbackResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating payment method status: $e');
    }
  }
}
