import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/auth_response.dart';
import 'package:responsive_app/configure/api_config.dart';

class AuthService {
  final String baseUrl = ApiConfig.serverUrl;

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      throw Exception('Error de conexión o autenticación: $e');
    }
  }

  Future<AuthResponse> register(
      String name, String email, String password) async {
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.first;
    final lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : firstName;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // En vez de parsear AuthResponse (ya que register solo devuelve el User), iniciamos sesión para obtener el token.
        return await login(email, password);
      } else {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Error al crear la cuenta');
      }
    } catch (e) {
      throw Exception('Error de conexión o registro: $e');
    }
  }

  Future<void> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = json.decode(response.body);
        throw Exception(
            body['message'] ?? 'Error al enviar el código de verificación');
      }
    } catch (e) {
      throw Exception('Error de conexión al solicitar código: $e');
    }
  }

  Future<void> verifyEmailCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Código inválido o expirado');
      }
    } catch (e) {
      throw Exception('Error de conexión al verificar código: $e');
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send-password-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Error al enviar el código de recuperación');
      }
    } catch (e) {
      throw Exception('Error de conexión al solicitar código de recuperación: $e');
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Código inválido o expirado');
      }
    } catch (e) {
      throw Exception('Error de conexión al restablecer contraseña: $e');
    }
  }
}

